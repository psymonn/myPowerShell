# Turn on some remoting stuff

Enable-PSRemoting

$allowUnencrypted = "WSMan:\localhost\Client\AllowUnencrypted"

Get-ChildItem $allowUnencrypted

Set-Item $allowUnencrypted $true

$trustedHosts = "WSMan:\localhost\Client\TrustedHosts"

Get-ChildItem $trustedHosts

Set-Item $trustedHosts *

# Oh, if only...

Invoke-Command . { Dir } 

# Domain controller

Invoke-Command DC1 { Dir C:\ }

# You can pass parameters ...

$driveName = "C:\"
Invoke-Command DC1 { Dir $using:driveName }

# There is another way to pass parameters ...

Invoke-Command DC1 { 
    param (
        $driveName
    )
    Dir $driveName
} -ArgumentList $driveName

# Or you can have an interactive session

Enter-PSSession EX1

## Switch network

# We're off our domain now
Test-Connection DC1 -Count 1

# We can connect to an internet server
Test-Connection INET1 -Count 1

# And we can remote control it
Invoke-Command INET1.isp.example.com { Dir C:\ } -Authentication Negotiate -Credential (Get-Credential "Administrator")

## Switch network back

## Demo before next slide
