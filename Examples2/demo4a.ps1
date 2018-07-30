#for remote management search for a cmdlet
get-command -noun "*share" | more
help new-smbshare
# invoke-command {mkdir c:\scripts} -comp srv1,srv2
invoke-command { get-item c:\scripts} -ComputerName srv1,srv2
#create hashtable to splat
$params = @{
Description = "Company scripts" 
Name = 'Scripts$'
FullAccess = "Company\Domain Admins"
Path = "C:\scripts"
CimSession = 'srv1','srv2'
}
New-smbshare @params

get-smbshare -CimSession srv1

#and remove them
Remove-SmbShare -Name 'scripts$' -CimSession srv1,srv2

cls

#or look for commands that have a -Cimsession parameter
get-command -ParameterName cimsession | more

cls