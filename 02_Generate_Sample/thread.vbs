' it is discovered that the job plugin will wait the vbs ends before terminate itself
' which make the vbs not working
' this act as an intermediate script to prevent the job plugin not terminated
Set WshShell = CreateObject("WScript.Shell")
if Wscript.Arguments.Count = 0 then
    Wscript.echo("Missing file name")
else
    ' execute the actual script to activate the synthesizing
    WshShell.Run("Wscript sync.vbs " & Wscript.Arguments(0))
end if
