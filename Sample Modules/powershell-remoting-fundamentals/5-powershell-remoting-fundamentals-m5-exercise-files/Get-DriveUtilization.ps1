
[cmdletbinding()]

Param (
[ValidateNotNullorEmpty()]
[string]$Drive="C:",
[ValidateNotNullorEmpty()]
[string]$Computername = $env:computername

)

Get-WmiObject -Class Win32_LogicalDisk -filter "DeviceID='$Drive'" -ComputerName $Computername |
Select @{Name="Computername";Expression={$_.SystemName}},
@{Name="OS";Expression={ (Get-WmiObject -class win32_operatingSystem -ComputerName $computername).caption}},
DeviceID,VolumeName,
@{Name="SizeGB";Expression={[int]($_.size/1gb)}},
@{Name="FreeGB";Expression={ [math]::Round($_.freespace/1gb,2)}},
@{Name="PctFree";Expression={ [math]::Round(($_.freespace/$_.size)*100,2)}}


