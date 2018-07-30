#demo trusted hosts

#just verifies computer is up
test-connection DMZ01

#try with credential
$cred = Get-Credential dmz01\administrator

#this has no effect on legacy commands
get-wmiobject win32_logicaldisk -filter drivetype=3 -ComputerName dmz01 -Credential $cred

#try remoting
invoke-Command { get-windowsfeature | where installed | select name } -computer DMZ01 -Credential $cred

#can verify. Remoting looks like it works
test-wsman DMZ01

cls

#read about TrustedHosts
help about_Remote_faq -ShowWindow

cls
#get current settings
get-item wsman:\localhost\Client\TrustedHosts

#add an exception. Use -Force to suppress confirmation
set-item wsman:\localhost\Client\TrustedHosts -Value DMZ* -Concatenate

<#
to set multiple entries, the value is a string, not an array

set-item wsman:\localhost\Client\TrustedHosts -Value "DMZ*,Nano*,Test22" -Concatenate

do not set trusted hosts to * because that means you will trust everything and you probably shouldn't.

#>

#verify
get-item wsman:\localhost\Client\TrustedHosts

#do a full test
test-wsman DMZ01 -Authentication Default -Credential $cred

#you need to specify a credential
icm { get-windowsfeature | where installed | select name } -computer DMZ01 -Credential $cred

cls

#region rollback demo

# set-item wsman:\localhost\Client\TrustedHosts -Value Nano* -force
# clear all entries
# set-item WSMan:\localhost\Client\TrustedHosts -Value "" -force

#endregion