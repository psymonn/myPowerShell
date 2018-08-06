#requires -version 4.0

#save remote modules not found locally

$Savepath="c:\work\helpdemo"

$local = get-module -list
$computers = "chi-dc04","chi-core01","chi-fp02","chi-hvr2"
$remote = $computers | foreach {
 Write-Host "Checking $_" -ForegroundColor Green
 get-module -list -CimSession $_ | where {$_.name -notin $local.name}
 } | Select -Unique 

 foreach ($module in $remote) {
  Write-Host "Saving help for $($module.name)" -ForegroundColor Green
  $module | Save-Help -DestinationPath $SavePath -Force
 }