function manifest()
	myManifest = {
		name          = "autoSync",
		comment       = "",
		author        = "",
		pluginID      = "{51ECCA1C-3895-4925-99D7-891741293D2A}",
		pluginVersion = "1.0.0.1",
		apiVersion    = "3.0.0.1"
	}
	return myManifest
end


----------------------
-- GENERATING SETUP --
----------------------

-- the dataset current is being synthesizing
DATASET             = "7"   

-- the auto generating will stop if the value in progress.txt is larger then this value
-- this value is used to control which singer's samples are generated
END_SAMPLE_IDX      = 333  

----------------------
-- GENERATING SETUP --
----------------------


--------------
-- CONSTANT --
--------------

LOGFILE_PATH        = "log.txt"
-- the file storing the generating progress
PROGRESSFILE_PATH   = "progress.txt"

-- the folder that store the sample csv files
SAMPLEFOLDER_PATH   = "../data/"..DATASET.."/sample"

LEN_UNIT            = 960
SAMPLE_LEN          = 4*LEN_UNIT
-- the duration of slience before every sample
PRE_POS_LEN         = 2*LEN_UNIT

ALLCONTROLTP        = { "DYN","BRE","BRI","CLE","GEN","PIT","PBS","POR" }
-- the parameter are used in this project
TYPE_LS             = { "BRE","BRI","CLE","GEN","GWL" }
-- csv columns
CSV_ALLCOL          = {
    "serial_number", "singer", "note_count", 
    "pitch_value_seq", "pitch_seq", "lyric_seq", "note_length_value_seq", "note_length_seq",
    "BRE", "BRI", "CLE", "GEN", "GWL", "OPE", "Vibrate"
}

--------------
-- CONSTANT --
--------------


function main(processParam, envParam)
    logFile, errMsg = io.open(LOGFILE_PATH, "a")
    if (not logFile) then
        logFile:write(errMsg+"\n")
        return
    end

    
    -- reset existing synthsizing setting
    resetAll()
    
    -- how many samples are set in this generating
    sample_cnt = 0 
    -- the current progress (index of sample)
    sample_idx = readProgress()
    -- to control where the sample is inserted to the timeline
    sample_position = 0

    -- terminate the plugin if the current is over the END_SAMPLE_IDX
    if sample_idx > END_SAMPLE_IDX then
        VSMessageBox("all sample sync",0)
        return 0
    end

    -- only maximum generate 333 sample once
    while sample_cnt < 333 and sample_idx <= END_SAMPLE_IDX do
        -- read the assigned setting of current sample
        sample_data_table = readSample(sample_idx);
        insertSample(sample_data_table, sample_position)

        -- move the time pointer
        sample_position = sample_position + PRE_POS_LEN + SAMPLE_LEN

        increaseProgress(1) -- increase the progress that is stored in progress.txt
        sample_cnt = sample_cnt+1
        sample_idx = sample_idx+1
    end

    logFile:write("Setup done\n")

    -- call the VBscript to start exporting the samples
    os.execute("Wscript thread.vbs "..(sample_idx-1))

    return 0
end

-- reset the synthesizing setting
function resetAll()
    -- clear note
    VSSeekToBeginNote()
    repeat
        resCode, note = VSGetNextNoteEx()        
        if (resCode == 1) then
            VSRemoveNote(note)
        end
    until (resCode == 0)

    -- clear vocal color parameter
    for _,contorl_tp in ipairs(ALLCONTROLTP) do
        resCode = VSSeekToBeginControl(contorl_tp)
        repeat
            resCode, control = VSGetNextControl(contorl_tp)
            if (resCode == 1) then
                VSRemoveControl(control)
            end
        until (resCode == 0)
    end
end


-- read the progress from the progress.txt
function readProgress()
    progress_file = io.open(PROGRESSFILE_PATH, "r")
    io.input(progress_file)
    sample_idx = io.read()
    progress_file:close()
    
    return tonumber(sample_idx)
end


-- increase the progress in the progress.txt by "increment"
function increaseProgress(increment)
    -- get the progress from progress.txt
    progress_file = io.open(PROGRESSFILE_PATH, "r")
    io.input(progress_file)
    cur_progress = io.read()
    progress_file:close()

    -- increase progress by the increment
    progress_file = io.open(PROGRESSFILE_PATH, "w")
    progress_file:write(cur_progress+increment)
    progress_file:close()
end


-- insert the sample with setting "sample_data_table" to "sample_position"
function insertSample(sample_data_table, sample_position)
    serial_num      = sample_data_table["serial_number"]
    note_cnt        = sample_data_table["note_count"]
    pitchV_seq      = splitStr(sample_data_table["pitch_value_seq"], " ")
    lyric_seq       = splitStr(sample_data_table["lyric_seq"], " ")
    noteLenV_seq    = splitStr(sample_data_table["note_length_value_seq"], " ")
    vibrate_tp      = sample_data_table["Vibrate"]
    opening         = sample_data_table["OPE"]

    -- set vocal color attribute parameter
    setParameter(sample_data_table, sample_position)

    -- insert notes
    note_position = sample_position
    for i=1, note_cnt do
        note = {
            posTick         = note_position,
            durTick         = noteLenV_seq[i],
            velocity        = "64",
            noteNum         = pitchV_seq[i],
            lyric           = lyric_seq[i],
            phonemes        = lyric_seq[i],
            vibratoLength   = "100",
            vibratoType     = getVibrateValue(vibrate_tp),        
            opening         = opening,
            bendDepth       = "0",
            bendLength      = "0",
            risePort        = "0",
            fallPort        = "0",
            decay           = "50",
            accent          = "50"
        }
        resCode = VSInsertNoteEx(note)
        note_position = note_position+noteLenV_seq[i]

        if (resCode == 0) then
            -- error occur
            logFile:write("Error occur when insert note "..i.." of sample "..serial_num.."\n")
            return
        end
    end
end


-- set parameter value
function setParameter(sample_data_table, sample_position)
    for _, tp in ipairs(TYPE_LS) do
        control = {
            posTick     = sample_position,
            durTick     = SAMPLE_LEN,
            value       = sample_data_table[tp],
            type        = tp
        }
        VSInsertControl(control)
    end
end


-- convert the vibrate type to value
function getVibrateValue(vibrate_tp)
    -- no vibration
    if (vibrate_tp == "1") then return "0" end;
    -- slight
    if (vibrate_tp == "2") then return "13" end;
    -- normal
    if (vibrate_tp == "3") then return "2" end;
    -- fast
    if (vibrate_tp == "4") then return "9" end;
    -- extreme
    if (vibrate_tp == "5") then return "5" end;
end


-- read next sample csv data, and then convert to a table
-- data table: (all str) 
--      serial_number
--      singer
--      note_count
--      pitch_value_seq
--      pitch_seq
--      lyric_seq
--      note_length_value_seq
--      note_length_seq
--      BRE
--      BRI
--      CLE
--      GEN
--      GWL
--      OPE
--      Vibrate
function readSample(sample_idx)
    logFile, errMsg = io.open(LOGFILE_PATH, "a")
    if (not logFile) then
        logFile:write(errMsg+"\n")
        return
    end

    -- read the setting of the sample
    sample_filename = SAMPLEFOLDER_PATH.."/"..sample_idx..".csv"

    -- logFile:write(sample_filename.."\n")

    sample_file = io.open(sample_filename)
    io.input(sample_file)
    sample_csv = io.read()
    sample_file:close()

    -- convert sample setting from csv to table
    sample_data_ls = splitStr(sample_csv, ",")
    sample_data_table = {}

    for i = 1, 15 do
        sample_data_table[CSV_ALLCOL[i]] = sample_data_ls[i]
    end

    return sample_data_table
end

function splitStr(line, sep)
    res = {}
    for str in string.gmatch(line, "([^"..sep.."]+)") do
        table.insert(res,str)
    end
    return res
end