Set WshShell = CreateObject("WScript.Shell")

' trigger job plugin
' ctrl + J
' enter
WshShell.SendKeys("^{j}")
WshShell.SendKeys("~")