function Get-ComputerSysInfo {
    Param (
        [string[]]$ComputerName
    )
    BEGIN {}
    #Not tested
    PROCESS{
        if ($_ -ne $null) {
            $ComputerName = $_
        }

        foreach ($computer in $ComputerName) {
            $wmi_param = @{ 'Class' = 'Win32_LogicalDisk';
                            'Filter' = "DriveType=3";
                            # 'Credential' = 'Administrator';
                             'ComputerName' = $computer
                          }
            $select_param = @{'Property' = 'Name', 'Manufacturer', 'Model'}
            Get-WmiObject @wmi_param | Select-Object @select_param
        }
    }
    END {}
}

get-content d:\scripts\computers.txt | Get-ComputerSysInfo
#Get-ComputerSystemInfo -computername DESKTOP-N5523PQ, DESKTOP-N5523PQ