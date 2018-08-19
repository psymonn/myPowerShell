#requires -version 3.0

<#
Write a basic function that takes a computer name as a parameter. 
Using Get-CIMInstance, have the function write an object that shows the 
computer name, when it last booted, how long it has been running and the 
percent of free space on the C:\drive. 

Give your function a meaningful and standard name.

#>

Function Get-Uptime {

Param([string]$Computername=$env:computername)

#get operating system information
$os = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $computername
#get C: drive information
$drive = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "deviceID='c:'" -ComputerName $computername
#calculate the percent free space
$Free = ($drive.freespace/$drive.size)*100

#create an ordered hashtable with properties for the custom object
$hashProperties = [ordered]@{
Computername = $OS.CSName
LastBoot = $OS.LastBootUpTime
Uptime = (Get-Date) - $OS.LastBootUpTime
PercentFree_C = $Free
}

#turn the hashtable into an object
[pscustomobject]$hashProperties

} #end function