#demonstrate PowerShell profile scripts in the PowerShell
$profile
$profile | select *host* | format-list
dir $profile
#create profile for current user current host
new-item $profile -Force
add-content -Value 'cd c:\scripts' -Path $profile
add-content -value '$var = 123' -Path $profile
add-content -Value '$host.privatedata.errorforegroundcolor="green"' -Path $profile
add-content -Value 'Write-Host "Hello Art. Have a nice day." -foregroundcolor magenta' -path $profile
#run a new PowerShell session
powershell
 # throw "var = $var"
 # exit
cls
#create profile for current user all hosts
new-item $profile.CurrentUserAllHosts -Force
add-content -value "set-alias np Notepad" -Path $profile.CurrentUserAllHosts

ise $profile
#look at ISE $profile
#get-alias np

help about_profiles
cls
#reset demo
# del $profile
# del $profile.currentuserallhosts