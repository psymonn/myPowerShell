#region start with a basic command

Get-Volume -DriveLetter C -CimSession $env:computername |
Select-object PSComputername,DriveLetter,Size,SizeRemaining,
@{Name="PctFree";Expression={($_.SizeRemaining/$_.size)*100}}

#endregion

#region Fine tune the output

Get-Volume -CimSession $env:computername |
Where-Object {$_.DriveLetter} |
Select-Object @{Name="Computername";Expression={$_.PSComputername}},
DriveLetter,FileSystem,
@{Name="SizeGB";Expression={$_.size/1gb -as [int32]}},
@{Name="FreeGB";Expression={[math]::Round($_.SizeRemaining/1gb,2)}},
@{Name="PctFree";Expression={[math]::Round(($_.SizeRemaining/$_.size)*100,2)}}

#that's a lot to type!
#what else is a challenge?

#endregion

