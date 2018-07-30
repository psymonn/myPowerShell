#
# Script.ps1
#
Param(
    [String]$ComputerName = (Read-Host "Compuer Name to query"),
    [int]$DriveType = 3                            
)
Get-WmiObject -Class win32_logicaldisk -Filter "DriveType=3" -ComputerName DESKTOP-N5523PQ|
Select-Object -Property @{n='ComputerName'; e={$_._SERVER}},
						@{n='Drive'; e={$_.DeviceID}}, 
						@{n='FreeSpace(GB)' ;e={$_.FreeSpace /1GB -as [int]}},
                        @{n='Size(GB)'; e={$_.size / 1GB -as [int]}
}

