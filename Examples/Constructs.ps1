$disk = Get-WmiObject -Class win32_logicaldisk | Select-Object -First 1
switch ($disk.DriveType) {
    2 {Write-Host "Floppy"}
    3 {Write-Host "Fixed"}
    5 {Write-Host "Optical"}
    default {Write-Host "Dunno"}
}

