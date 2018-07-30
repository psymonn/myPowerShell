#credentials require a CIMSession
help New-CimSession
New-Cimsession -ComputerName srv1,srv2,dom1 -credential company\administrator
#you might also need a session to support DCOM on an older system
#or need another tweak
help New-CimSessionOption
cls
$opt = New-CimSessionOption -Protocol Dcom
#works for any machine
$s3 = New-CimSession -ComputerName srv3 -Credential srv3\administrator -SessionOption $opt

Get-Cimsession
cls
Get-CimInstance win32_computersystem -CimSession $s3


get-cimsession | get-ciminstance win32_logicaldisk -filter "deviceid='c:'" | 
Select @{Name="Computername";Expression={$_.pscomputername.toUpper()}},
Caption,@{Name="SizeGB";
Expression={($_.Size/1gb) -as [int]}},
@{Name="FreeGB";Expression={[math]::round($_.Freespace/1gb,2)}},
@{Name="PctFree";Expression={[math]::Round(($_.freespace/$_.size)*100,2)}} |
Sort PctFree | Format-Table

cls

#cimsessions will automatically be removed
#or manually remove them
Get-CimSession | Remove-CimSession
Get-CimSession

cls