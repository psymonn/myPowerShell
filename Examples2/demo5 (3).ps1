'dom1','srv1' | foreach {Test-Netconnection -ComputerName $_ -port 53  }

cls

