
#group policy is a better approach
get-command -noun netfirewallrule

get-NetFirewallRule | Out-GridView -Title "FW Rules"

get-netfirewallrule -Enabled True | 
Select Name,Displayname,Description,Profile,DisplayGroup,Direction,Action |
more

cls
#filter for domain policies

get-netfirewallrule -Name FPS*  | 
where profile -contains 'domain'| 
select name,enabled,Direction,Action

Disable-NetFirewallRule FPS-ICMP6* -WhatIf

cls
#find disabled domain policies

get-netfirewallrule -Enabled false | where profile -contains 'domain' |
Select name,description

cls

#enable disabled remote* rules
#Using Group Policy is better

get-netfirewallrule remote* | 
where {$_.profile -contains 'domain' -AND $_.enabled -eq 'false'} |
Enable-NetFirewallRule -WhatIf

cls
#remote management requires PowerShell remoting we'll cover in next module
help Get-NetFirewallRule -Parameter cimsession

Get-NetfirewallRule remote* -CimSession srv2 | Select Name,DisplayName,Profile,Enabled,PSComputername
cls

