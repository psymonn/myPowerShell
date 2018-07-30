param (
    [string[]] $ComputerNames
)

foreach ($ComputerName in $ComputerNames){
    $os = Get-WmiObject -Class win32_operatingsystem -ComputerName $ComputerName
    $cs = Get-WmiObject -Class win32_computersystem -ComputerName $ComputerName
    $bios = Get-WmiObject -Class win32_BIOS -ComputerName $ComputerName

    $props = [ordered] @{'ComputerName' = $ComputerName;
                'OSVersion' = $os.Version;
                'SPVersion' = $os.SerialNumber;
                'Mfgr' = $cs.manufacturer;
                'Model' = $cs.model;
                'RAM' = $cs.totalphysicalmemory;
                'BIOSSerial' = $bios.serialnumber
            }
    $obj = New-Object -TypeName PSObject -Property $props
    write-output $obj
}

#You can specify any order you want..e.g
#PS D:\scripts\Module> d:\scripts\Module\Get-DiskInfo2 DESKTOP-N5523PQ, DESKTOP-N5523PQ | select-object -Property computername, ram, model
