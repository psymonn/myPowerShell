#requires -version 3.0

#this is an intentionally buggy script

#set-strictmode -version latest

#$debugpreference="continue"
#$verbosePreference="continue"

#default to the local computer
$computer = $env:computername

$properties = "PSComputername,Name,Displayname,Startname,StartMode,State"

Write-Host "Getting services from $computr" -ForegroundColor Green

$svcs = Get-CimInstance win32_service -comp $computer

$data = $svcx | select $propeties 

#note that including formatting like this isn't normally recommended 
#in your script, but I did for demonstration purposes.
$data | sort StartName | 
format-table -GroupBy Startname Name,Displayname,startMode,State,PSComputername

write-host "Finished" -ForegroundColor Magenta

