#or filter. Disable warnings for failures
'dom1','srv1' | where {Test-Netconnection -ComputerName $_ -port 53 -InformationLevel Quiet -WarningAction SilentlyContinue }
cls