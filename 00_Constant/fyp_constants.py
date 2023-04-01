import os

########
# Path #
########
ROOT                = os.path.abspath(os.path.join(os.getcwd(), "..")  )
DATA_FOLDER_PATH    = f"{ROOT}\\data" 
MODEL_FOLDER_PATH   = f"{ROOT}\\model"
FIGRUE_FOLDER_PATH  = f"{ROOT}\\figrue" # folder stores the boxplot in external test
EXTERNALTEST_DATA_FOLDER_PATH = f"{DATA_FOLDER_PATH}\\external" # the folder store the external test recordings

STEP01_PATH                 = f"{ROOT}\\01_Generate_Setting"
NOTESEQ_CSVFILE_PATH        = f"{STEP01_PATH}\\noteSeq.csv"
LYRIC_CSVFILE_PATH          = f"{STEP01_PATH}\\lyric.csv"

ALLSAMPLE_CSVFILE_NM        = "allSample.csv"   # name of the csv file store all sample setting of a dataset

EXTERNALTEST_DATA_CSVFILE_PATH = f"{EXTERNALTEST_DATA_FOLDER_PATH}\\external.csv"

DATA_CSV_FOLDER_NM          = "csv"             # name of folder store csv file of a dataset
DATA_SAMPLE_FOLDER_NM       = "sample"          # name of folder store samples' csv file of a dataset
DATA_RAW_FOLDER_NM          = "raw"             # name of folder store raw generated audio of a dataset
DATA_SAMPLEWAV_FOLDER_NM    = "sampleWav"       # name of folder store clipped sample of a dataset
DATA_PROCESSED_FOLDER_NM    = "processData"     # name of folder store processed data of a dataset


##################
# Sample Setting #
##################
SAMPLE_LEN      = 4                 # a sample is in 4 second length
NOTELEN_LS      = [0.5, 1, 2, 4]    # all note length in this project, in seconds
NOTELEN_UNIT    = 960               # value of 1 second note in Vocaloid 4

PARAMETERTYPE_LS    = ["BRE","BRI","CLE","GEN","GWL","OPE","Vibrate"]   # name of 7 parameter of Vocaloid 4 used in this project
NOTESCALE           = ["C","C#","D","Eb","E","F","F#","G","G#","A","Bb","B"]    # all possible note scale

SAMPLING_RATE   = 44100
LOUDNORM_LUFS   = -23.0     # the LUFS value used for loudness normalization


###################
# Data Processing #
###################
DATAX_MEL64_NM      = "data_x_mel64"
DATAX_MEL128_NM     = "data_x_mel128"
DATAX_MEL256_NM     = "data_x_mel256"
DATAX_WAVE_NM       = "data_x_wave"
DATAX_WAVE_HALF_NM  = "data_x_wave_half"    # npz name of data x in prue waveform, half size of the original dataset

DATAY_NO_PROC_NM            = "data_y_no_proc"              # npz name of data y without any processing
DATAY_NO_PROC_HALF_NM       = "data_y_no_proc_half"
DATAY_PROC_VIB_NM           = "data_y_proc_vib"             # npz name of data y with scaling up vibrate
DATAY_PROC_VIB_GEN_NM       = "data_y_proc_vib_gen"
DATAY_PROC_VIB_GEN_BRE_NM   = "data_y_proc_vib_gen_bre"
DATAY_PROC_VIB_GEN_BRI_NM   = "data_y_proc_vib_gen_bri"
DATAY_PROC_VIB_GEN_GWL_NM   = "data_y_proc_vib_gen_gwl"
DATAY_PROC_GEN_MINMAXNORM   = "data_y_proc_gen_minmaxnorm"  # npz name of data y with processed gen value & min max normalization

MEL_MAX_FREQ = 20000    # the max frequency of processed mel scake spectrogram


##################
# Model Training #
##################
XSHAPE_MEL64    = (64,345,1)
XSHAPE_MEL128   = (128,345,1)
XSHAPE_MEL256   = (256,345,1)
XSHAPE_WAVE     = (4*SAMPLING_RATE,1)
YSHAPE          = 7


#################
# Model Testing #
#################
EXTERNAL_TESTING_SIZE = 577 # same as the file name of the last testing sample