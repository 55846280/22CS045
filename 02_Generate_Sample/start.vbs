' act as the entry of the auto-generate process
Set WshShell = CreateObject("WScript.Shell")
' after start this script, click to Vocaloid 4 software within 5 seconds
WScript.Sleep(5000)
WshShell.run("WScript setup.vbs")