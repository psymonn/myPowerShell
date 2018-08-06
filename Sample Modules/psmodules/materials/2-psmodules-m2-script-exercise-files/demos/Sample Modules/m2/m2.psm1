#    M2.PSM1
#    A more complex version of this module
Write-Host "Loading More Complex Module M2"
#    Define a function, assign a variable
Function Get-Greeting { "Hello World From Complex Script Module"}
$HW = Get-Greeting                     
#    Set an alias
Set-Alias  HW  Get-Greeting
#    Export module members
Export-ModuleMember -Variable *
Export-ModuleMember -Alias    *
Export-ModuleMember -Function "*"
#    Specify removal action 
$mdet = $MyInvocation.MyCommand.ScriptBlock.Module
$mdet.OnRemove = {Write-Host "M2 removed on $(Get-Date)"}
