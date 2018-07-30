function Get-ComputerSystemInfo {
    Param (
        [string[]]$ComputerName
    )
    #don't do it this way was adv
    Write-Host "Input is $input"
    if ($input -ne $null) {
        $ComputerName = $input
    }
    Get-WmiObject -Class win32_computersystem -ComputerName $ComputerName |
	    Select-Object -Property name, manufacture,  model
}


get-content d:\scripts\computers.txt | Get-ComputerSystemInfo

#Get-ComputerSystemInfo -computername DESKTOP-N5523PQ, DESKTOP-N5523PQ