Get-command -module Microsoft.PowerShell.Archive
Compress-archive -path .\documents\* -destinationpath .\documents\transcripts.zip

$string = “Don_Jones”
$string | convertFrom-String -delimiter _  -propertyNames FirstName, LastName

Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" | Select-Object ProductID 
Get-ItemPropertyValue HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion -Name ProductID

Clear-recyclebin C:\ -Force

New-GUID

New-temporaryfile

Get-childitem ‘C:\Program Files\WindowsPowerShell’ -depth 2