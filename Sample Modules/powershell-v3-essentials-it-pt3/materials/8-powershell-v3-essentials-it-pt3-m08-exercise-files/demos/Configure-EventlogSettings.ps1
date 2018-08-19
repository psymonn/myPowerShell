#requires -version 3.0

$computers = "chi-dc01","chi-dc02","chi-dc04","chi-fp01","chi-fp02"

Get-EventLog -list -computer $computers | 
Where {$_.logdisplayname -eq 'system'} |
Select @{Name="Computername";Expression={$_.Machinename}},
MinimumRetentionDays,MaximumKilobytes,OverFlowAction 

help Limit-EventLog -ShowWindow

$limitParam = @{
  Maximumsize = 32MB
  logname = "System"
  RetentionDays = 30
  OverflowAction = "OverwriteOlder"
}

foreach ($computer in $computers) {
 Write-Host "Setting limits on $($limitParam.logname) log on $($Computer.ToUpper())" -ForegroundColor Cyan
 
 #add the computer to the hashtable
 $limitParam.Computername = $computer

 #remove WhatIf to make the change
 Limit-EventLog @limitParam -whatif

}

#re-run report