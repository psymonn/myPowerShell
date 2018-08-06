#demo CredSSP


#region the 2nd hop problem

#export some certificate information to a network share
#icm is an alias for Invoke-Command

icm { dir Cert:\LocalMachine\trust*,Cert:\LocalMachine\ca -Recurse | export-clixml \\chi-fp02\IT\chi-core01-trusted.xml } -computer chi-core01

icm { dir \\chi-fp02\IT\ } -computer chi-core01

#path is good
test-path \\chi-fp02\it

cls
#endregion

#region Configuring for CredSSP

get-command -noun *credssp*

help get-wsmancredssp

get-wsmancredssp

icm { get-wsmancredssp } -computername chi-core01

help enable-wsmancredssp

#enable the client
enable-wsmancredssp -role Client -DelegateComputer chi-core01

get-wsmancredssp

#enable the server
icm { enable-wsmancredssp -role Server -force } -computername chi-core01
icm { get-wsmancredssp } -computername chi-core01

cls

#endregion

#region Using CredSSP

icm { dir \\chi-fp02\IT\ } -computer chi-core01

#need to specify CredSSP and credentials
icm { dir \\chi-fp02\IT\ } -computer chi-core01 -Authentication Credssp

$cred = Get-Credential globomantics\squick
icm { dir \\chi-fp02\IT\ } -computer chi-core01 -Authentication Credssp -Credential $cred

icm { dir Cert:\LocalMachine\trust*,Cert:\LocalMachine\ca -Recurse | export-clixml \\chi-fp02\IT\chi-core01-trusted.xml } -computer chi-core01 -Authentication Credssp -Credential $cred

Test-Path \\chi-fp02\it\chi-core01-trusted.xml

cls

#endregion

#region Disable it

help disable-wsmancredssp

disable-wsmancredssp -role Client
icm { disable-wsmancredssp -role Server } -computername chi-core01

get-wsmancredssp
icm { get-wsmancredssp } -computername chi-core01

#endregion