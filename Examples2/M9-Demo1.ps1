#demo disconnected sessions

help about_Remote_Disconnected_Sessions
cls
help invoke-command -Parameter InDisconnectedSession

cls

invoke-command -FilePath S:\Get-LogReport.ps1 -computername chi-core01 -ArgumentList 1000 -InDisconnectedSession

#find users created in the last 30 days
$sb = {
$n = (Get-Date).AddDays(-30).Date
get-aduser -filter {whencreated -ge $n} -Properties *
}

invoke-command -ScriptBlock $sb -ComputerName chi-dc04 -InDisconnectedSession -SessionName NewUsers

get-pssession

exit

