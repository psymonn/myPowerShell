# Contents of Harmless-Command.ps1
function Freak {
    
    Start-Process notepad.exe
    start-sleep 1
    get-process -Name notepad | stop-process
    write-output "Freaky"

    }
Freak

#search event log for script block logging
Get-winevent -filterHashTable @{ProviderName = “Microsoft-Windows-PowerShell”;ID=4104} | where-object {$_.Message -like “*Freaky*”} | select-object -expandproperty Message