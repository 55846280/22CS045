Set WshShell = CreateObject("WScript.Shell")

if Wscript.Arguments.Count = 0 then
    Wscript.echo("Missing file name")
else
    ' Setup Phonmes
    ' alt+L
    ' enter
    WshShell.SendKeys("%{l}")
    WshShell.SendKeys("~")

    Wscript.Sleep(1000)

    ' Export
    ' ctrl+alt+shift+s
    ' enter
    ' file name
    ' enter
    WshShell.SendKeys("^%+{s}")
    WshShell.SendKeys("~")
    WshShell.SendKeys(Wscript.Arguments(0))
    WshShell.SendKeys("~")

    ' 150 seconds timeout to wait the exporting
    Wscript.Sleep(150000)

    ' run the script to trigger next setup
    WshShell.Run("Wscript setup.vbs")
end if