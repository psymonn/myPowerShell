filter Get-ComputerSystemInfo {
    Get-WmiObject -Class win32_computersystem -ComputerName $_ |
            Select-Object -Property name, manufacture,  model       
}
get-content d:\scripts\computers.txt | Get-ComputerSystemInfo