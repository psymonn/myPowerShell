#requires -version 4.0

#View and test DSC Configurations for Chicago Globomantics servers

#region Get DSC 
Get-DscConfiguration -CimSession chi-fp02

$computers = "chi-core01","chi-fp01","chi-fp02"

$all = Get-DscConfiguration -CimSession $computers
$all.count

$all.where({$_.cimclass -match "service"}) | 
Select PSComputername,Name,State,StartUptype

$all.where({$_.cimclass -match "file" -AND $_.ensure -eq 'Absent'}) | 
Select PSComputername,DestinationPath

#endregion

#region Test DSC
Test-DscConfiguration -CimSession chi-core01 
Test-DscConfiguration -CimSession chi-fp02
Test-DscConfiguration -CimSession chi-fp02 -verb

#endregion

#region remediate
(Get-Content S:\ChicagoServers.txt).where(
{-Not (Test-DscConfiguration -CimSession $_)}).foreach({
Restore-DscConfiguration -CimSession $psitem -verbose})

Test-DscConfiguration -CimSession $computers

<# alternative

(Get-Content S:\ChicagoServers.txt).foreach({
if (-Not (Test-DscConfiguration -CimSession $psitem)) {
    Restore-DscConfiguration -CimSession $psitem -verbose
}
}
)

#>

#endregion
