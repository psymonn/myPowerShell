#demo troubleshooting

# To setup demo run these commands on chi-core02
# disable-psremoting
# stop-service winrm and disable it

#tries a command

icm { get-process -IncludeUserName | sort VM -Descending | select -first 5} -computer chi-core02 | 
format-table ID,Name,Username,VM -AutoSize

#ping test assumes you have enabled it in your network
#only shows that server is up and running
Test-Connection -ComputerName chi-core02

#test WSMan
Test-WSMan chi-core02

#check eventlogs
get-eventlog -LogName system -newest 200 -ComputerName chi-core02 | group source -NoElement | ft -AutoSize

#define a hashtable of parameters
$evt = @{Logname="System";Source="Winrm";Newest=50;ComputerName="chi-core02"}
get-eventlog @evt | format-table EntryType,Message -wrap -AutoSize

$evt.source = "Service Control Manager"
$evt.Message = "*Remote Management*"
get-eventlog @evt | format-table EntryType,UserName,Message -wrap -AutoSize

#see what is in other logs
get-winevent -ListProvider *winrm*
#list enabled logs
get-winevent -listlog *winrm*

$logs = get-winevent -logname "Microsoft-Windows-WinRM/Operational" -MaxEvents 5 -computername chi-core02 
$logs
$logs | select OpCodeDisplayname,User*,Time*,Message | format-list

#resolve the side
[wmi]"root\cimv2:Win32_SID.Sid='S-1-5-21-2552845031-2197025230-307725880-14309'" 

$logs | 
select @{Name="User";Expression={ ([wmi]"root\cimv2:Win32_SID.Sid='$($_.userid)'").AccountName }},
Message,*DisplayName

#check the service
Get-Service winrm -computername chi-core02

#restart
Get-Service winrm -computername chi-core02 | start-service -PassThru

#use WMI 
get-wmiobject win32_service -filter "name='winrm'" -ComputerName chi-core02

#re-enable
get-service winrm -ComputerName chi-core02 | 
set-service -StartupType Automatic -PassThru | 
start-service -PassThru

cls

