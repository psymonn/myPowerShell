#demo scripting securityii

Get-ExecutionPolicy 
cd c:\scripts
dir sample.ps1
get-content sample.ps1
#try to run it
sample.ps1
#need the path
.\sample.ps1
#we'll add some formatting to make it easier to read
.\sample.ps1 | Format-Table -AutoSize
cls
#change policy
Set-ExecutionPolicy restricted
Get-ExecutionPolicy
.\sample
Set-ExecutionPolicy allsigned -Force
.\sample
Set-ExecutionPolicy unrestricted -Force
.\sample
Set-ExecutionPolicy remotesigned -Force
#get a file from the internet
.\downloaded.ps1
#look at the file in Explorer
invoke-item .
#you can unblock from PowerShell
unblock-file C:\scripts\downloaded.ps1
.\downloaded.ps1

help about_Execution_Policies
cls
