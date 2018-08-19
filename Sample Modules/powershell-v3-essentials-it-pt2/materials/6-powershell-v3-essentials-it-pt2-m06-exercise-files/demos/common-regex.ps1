
#region LIKE

"jeff" -like "j*"

"JEFF" -like "*ff"

"jeff" -like "myles"

get-content c:\work\computers.txt | 
where {$_ -like "*DC*" -and !(Test-Connection $_ -quiet -Count 1)} 

#endregion

#region MATCH

#match uses regular expressions

"jeff" -match "j"
#$matches created automatically
$Matches

"JEFF" -match "ff"
$Matches

"jeff" -match "J.ff"
$matches

get-process | 
where {$_.company -AND $_.company -notmatch "Microsoft"} | 
Select Name,Company

#beware of floating
"powershell" -match "pow"
$matches
"turtlepower" -match "pow"
$matches
"powershell" -match "^pow"
"turtlepower" -match "^pow"

"powershell" -match "^powershell$"
$matches
"powershelll" -match "^powershell$"

dir "\\chi-fp01\executive" -filter "datareport*.docx" |
Where {$_.name -match "t\d{2}\.docx$"}


#endregion

#region common regular expression patterns

#region unc
$unc = "\\\\\w+\\\w+"

"\\server01\public","server\public","\\server-3\files","\\server\share\folder" | 
where {$_ -notmatch $unc}

#endregion

#region Logon

$names = "globomantics\jeff","domain\jeff\foo","globo2\admin"
$acct = "\w+\\\w+"
#beware of float
$names | where {$_ -match $acct}

$acct = "^\w+\\\w+$"
$names | where {$_ -match $acct}


#endregion

#region ipv4 address
$ips = "172.16.30.200","172.16.3.4","172.16.30.203","10.100.10.1000","100.200.300.400" 

$ip = "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"

$ips | where {$_ -match $ip}


#fix the float
$ip = "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"
$ips | where {$_ -match $ip}

#or narrow it down
$ip = "^172\.16\.30\.\d{1,3}$"
$ips | where {$_ -match $ip} | Resolve-DnsName | Select Name,Server

#endregion

#region phone number

$phone="\d{3}-\d{4}"

#get all users with a phone number defined
$users = get-aduser  -filter "telephonenumber -like '*'" -property telephonenumber 
$users | select Name,*number

#find users with a mis-entered phone
$users | where {$_.telephonenumber -notmatch $phone} |
Select Distinguishedname

#endregion


#endregion