#requires -version 3.0

#Active Directory Health Check
#Requires the AD PowerShell module from RSAT

Get-ADDomain | 
Select Forest,NetBiosName,DomainMode,PDCEmulator,RIDMaster,InfrastructureMaster 

Get-ADForest | Select Name,ForestMode,GlobalCatalogs,*Master

#get all domain controllers for the domain
$domain = Get-ADDomain
$DCs = Get-ADDomainController -Filter { Domain -eq $domain.dnsroot }

$dcs | Select Name,OperatingSystem,IPv4Address

#verify services
$services = "netlogon","NTDS","KDC","ADWS","NTFRS"

Get-Service $services -ComputerName $DCs.name | 
Sort Machinename,Name | 
Select Name,Displayname,Status,Machinename | 
Out-GridView -Title "AD Service Status"

#check logs
$lognames = 'Active Directory Web Services',
'Directory Service','File Replication Service',
'System'

#get recent errors and warnings from these logs from all DCs
$mylogs = foreach ($logname in $lognames) {
  Write-Host $logname -ForegroundColor Yellow
  #add the eventlog name to the output object
  Get-EventLog $logname -ComputerName $DCs.name `
  -newest 10 -EntryType Error,Warning |
  Add-Member -MemberType NoteProperty -Name LogName `
  -Value $logname -PassThru
 } 

#view, filter and analyze
$mylogs | Sort Logname,MachineName,TimeGenerated |
Select Logname,Machinename,TimeGenerated,EventID,
EntryType,Source,Category,Message |
Out-GridView -Title "AD Event Logs"

#create an HTML report
$head = @"
<style>
body { background-color:#FFFFFF;
       font-family:Verdana;
       font-size:10pt; }
td, th { border:0px solid #000033; 
         border-collapse:collapse; }
th { color:white;
     background-color:#000033; }
table, tr, td, th { padding: 0px; margin: 0px ;width:80%}
tr:nth-child(odd) {background-color: lightgray}
table { margin-left:25px; }
H1 {
  color:green
}
</style>
<Title>AD Event Check</Title>
"@ 

$Fragments = @"
<H1>Globomantics.Local</H1>      
<hr>
<br>
"@

#get eventlogs grouped by domain controller
$grouped = $mylogs | Group Machinename

foreach ($DC in $grouped) {
  $fragments += $DC.Group | 
 Sort Logname,TimeGenerated |
 Select Logname,TimeGenerated,EventID,
 EntryType,Source,Category,Message | 
 ConvertTo-Html -Fragment -As Table -PreContent "<H2>$($DC.name)</H2>"
}

#html body must be a single string
$html = ConvertTo-Html -Title "AD Event Report" -Head $head -Body $fragments | Out-String

#send it as a mail message
$mailParams = @{
To = "jeffhicks@globomantics.local","royg.biv@globomantics.local"
CC = "jfrost@globomantics.local"
From = "powerShell@globomantics.local"
Subject = "AD Event Log Report"
Body = $html
BodyAsHTML = $True
SMTPServer = "chi-ex01.globomantics.local"
}

Send-MailMessage @mailParams

