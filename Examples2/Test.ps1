. Get-..\..\04\demos\Get-ServiceProperty.ps1

#Get-ServiceProperty -Name RemoteRegistry

#Get-ServiceProperty -Name RemoteRegistry -Property *

#Get-ServiceProperty -Name RemoteRegistry -Property StartName,DelayedAutoStart,PathName

Get-Service RemoteRegistry | Get-ServiceProperty


#Get-WmiObject -Class Win32_Service -Filter "Name = 'RemoteRegistry'"| Select-Object Status
