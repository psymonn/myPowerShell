function Get-LatestSecurityLog {
    param(
        [string]$ComputerName
    )
    Get-EventLog -LogName Security -Newest 50 -ComputerName $ComputerName
}

function Get-OSInfo{
    param(
    [string]$ComputerName
    )
    Get-CimInstance -ClassName Win32_BIOS -ComputerName $ComputerName
}

Get-OSInfo -ComputerName DESKTOP-N5523PQ

# PS D:\scripts\Module> Import-Module MyTools
# PS D:\scripts\Module> Remove-Module MyTools
# PS D:\scripts\Module> Import-Module MyTools
# PS D:\scripts\Module> help Get-OSInfo

#Upto Video 49