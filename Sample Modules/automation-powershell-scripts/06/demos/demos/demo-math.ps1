#demonstrate the math class

[math]
#this is a .NET trick to list all the members of a class
[math].GetMembers() | Select Name,MemberType -unique | sort MemberType,Name | more
#fields
[math]::PI
[math]::E

#some common functions
[math]::Pow.OverloadDefinitions
[math]::Pow(3,2)
[math]::Sqrt(144)
cls

$n = 1234.5678
[math]::Truncate($n)
[math]::Round($n,2)
$n -as [int]
cls
#practical use
#these commands could be turned into scripts

dir $env:temp -file -Recurse | Measure-Object Length -sum | 
Select Count,@{Name="SumMB";Expression = {[math]::round($_.sum/1mb,3)}}

#values are in KB
Get-CimInstance win32_operatingsystem | Select *memory*

Get-CimInstance Win32_OperatingSystem -ComputerName $env:computername | 
Select PSComputername,@{Name="TotalMemGB";Expression={$_.totalvisiblememorysize/1MB -as [int]}},
@{Name="FreeMemGB";Expression={ [math]::Round(($_.freephysicalmemory/1Mb),4)}},
@{Name="PctFreeMem";Expression = {[math]::Round(($_.freephysicalmemory/$_.totalvisiblememorysize)*100,2)}}

