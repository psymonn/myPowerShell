
'srv2','srv3' | foreach {Test-netconnection -ComputerName $_ -CommonTCPPort SMB }

cls