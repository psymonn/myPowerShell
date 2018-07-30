
#you can use legacy cmd commands
ping dom1

#better to use PowerShell commands
help test-connection
#can test one or more computers at a time
help test-connection -param computername

cls
test-connection dom1
test-connection srv1,srv2,srv3 -Count 1 -Protocol DCOM
#use -quiet to filter
"srv1","srv2","192.168.3.99","dom1" | where { Test-Connection -Quiet -ComputerName $_ -count 1}

cls
