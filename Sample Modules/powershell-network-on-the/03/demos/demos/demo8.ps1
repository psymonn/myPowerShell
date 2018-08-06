
help Resolve-DnsName
cls
Resolve-DnsName www.pluralsight.com
#SRV4 is bad entry in my HOSTS file
Resolve-DnsName srv4.company.pri | select *
#check DNS Server only. I manually added an entry
Resolve-DnsName srv4.company.pri -DnsOnly

cls
