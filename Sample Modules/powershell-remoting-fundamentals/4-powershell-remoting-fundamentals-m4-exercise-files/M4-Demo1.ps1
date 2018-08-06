#demo interactive remoting


<#
 Jeff: run the demo scripts as outlined
#>

#region Enter-PSSession

# std C:\work\M4-1.txt

get-command -noun PSSession
help enter-pssession

test-wsman chi-web02

# stdr -comp chi-web02 -file c:\work\M4-2.txt

Enter-PSSession -ComputerName chi-web02
hostname
dir c:\
cd \

#connections invisible to any console-based user
#this is the remote process
get-process wsmprovhost -includeusername | select Username,starttime

#commands run locally
get-windowsfeature web* | where installed
get-service | where {$_.status -eq 'Running'}
$s = "bits"
$s
gsv $s

get-module web* -list
import-module web*
cd iis:
dir
dir sites
dir '.\Sites\Default Web Site'
get-website Default* | Stop-Website -Passthru
start-website Default* -Passthru

exit

#endregion

#region Using PSSessions

# stdr -comp chi-core01 -file C:\work\M4-3.txt

Enter-PSSession -ComputerName chi-core01
$p = get-process
$p
exit

#tries to connect to previous session

# stdr -comp chi-core01 -file C:\work\M4-4.txt

Enter-PSSession -ComputerName chi-core01
$p | sort WS -Descending | Select -first 5
get-variable p
exit

# std c:\work\M4-5.txt
Help New-PSSession
$s = new-pssession -computername chi-core01
Get-PSSession

# stdr -file c:\work\M4-6.txt -session $s

Enter-PSSession -Session $s
$p = get-process
$p
exit

#re-enter the session
# run this to recreate the variable
# $s = Get-pssession
# stdr -file c:\work\M4-7.txt -session $s 
Enter-PSSession -Session $s
$p | sort WS -Descending | Select -first 5
exit

#endregion


#region Invoke-Command

# std c:\work\M4-8.txt
help invoke-command
invoke-command -ScriptBlock { dir Cert:\LocalMachine\My } -ComputerName chi-core01
invoke-command -ScriptBlock { $p = get-process } -ComputerName chi-core01
#Scriptblock parameter is positional
invoke-command { $p | select -first 3 } -ComputerName chi-core01

get-alias -Definition Invoke-Command
icm { $p = Get-Process  b  | sort WS -Descending} -session $s
icm { $p[0..4] } -session $s

#results are deserialized xml so no methods
icm { $p[0] } -session $s | get-member

#get rid of the session
remove-pssession $s

cls

#endregion


#region Using the PowerShell ISE

ISE 

# File - New Remote PowerShell Tab

# remoting works as well
enter-pssession chi-dc02

#endregion