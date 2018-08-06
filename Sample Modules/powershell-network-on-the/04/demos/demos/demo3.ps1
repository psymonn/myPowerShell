
#region non-domain machines

ping srv3
test-connection srv3

#this is a problem
get-service -ComputerName srv3

test-wsman srv3
#you can also use this
# test-netconnection srv3 -CommonTCPPort WINRM
#this won't work
invoke-command { get-service } -computername srv3

#maybe test with credential?
$cred = Get-Credential srv3\administrator
test-wsman -ComputerName srv3 -Credential $cred -Authentication Negotiate

#need to manually trust SRV3
#remoting has a WSMAN: PSDrive for configuration information
#you must be in an elevated session
Get-Item -Path WSMan:\localhost\Client\TrustedHosts
#this can also be set via Group Policy
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value SRV3
dir WSMan:\localhost\Client
#now this will work
test-wsman -ComputerName srv3 -Credential $cred -Authentication Negotiate
invoke-command { get-service } -computername srv3 -Credential $cred
#or create a pssession to re-use
$s = new-pssession srv3 -Credential $cred
invoke-command { get-eventlog system -newest 5} -session $s
remove-pssession $s
#reset trusted hosts
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value "" -force
cls

#endregion