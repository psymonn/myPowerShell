function Get-ComputerSystemInfo {
    Param (
        [string[]]$ComputerName
    )
    BEGIN {}
    #ONLY loop through one at a time so foreach is redudant
    PROCESS{
        if ($_ -ne $null) {
            $ComputerName = $_
        }

        foreach ($computer in $ComputerName) {
            Get-WmiObject -Class win32_computersystem -ComputerName $computer |
                Select-Object -Property name, manufacture,  model
        }
    }
    END {}
}

get-content d:\scripts\computers.txt | Get-ComputerSystemInfo
#Get-ComputerSystemInfo -computername DESKTOP-N5523PQ, DESKTOP-N5523PQ