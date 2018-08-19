#requires -version 3.0

#demo creating a new file share

$FS = "CHI-FP02"

#region Add Windows Feature

#check installed features
Get-WindowsFeature -ComputerName $FS | where {$_.installed}

#or use new syntax
# Get-WindowsFeature -ComputerName $FS | where installed

$features = 'FS-FileServer','FS-Data-Deduplication','FS-Resource-Manager'

# Remove-WindowsFeature -computername $FS -name $features
# Get-WindowsFeature -ComputerName $FS -Name $features

Add-WindowsFeature -ComputerName $FS -Name $features 

Restart-Computer $FS -force -Wait -for PowerShell

#endregion

#region Create folder

#use a remote command
#create a remoting session
$remote = New-PSSession -ComputerName $FS

$newpath = "C:\Shared\SalesData"
Invoke-Command {mkdir $using:newpath} -session $remote

#endregion

#region Set folder NTFS permissions

#look at current settings
Invoke-command {
 Get-Acl $using:newpath | 
 select -expand access | 
 Select IdentityReference,FileSystemRights,AccessControlType
 } -session $remote -HideComputerName

#turn off inheritance
$sb = {
 $acl = Get-ACL -Path $using:newpath
 $access=$acl.Access
 #preserve inherited access rules
 $acl.SetAccessRuleProtection($True,$True)
 Set-Acl $using:newPath $acl
}

Invoke-Command $sb -session $remote

#remove Builtin\Users
$sb = {
 $acl = Get-ACL -Path $using:newpath
 $access=$acl.Access
 [System.Security.Principal.NTAccount]$principal="Builtin\Users"
 $rule=$access | where {$_.IdentityReference -eq $principal}
 
 $rule | foreach {
   $acl.RemoveAccessRuleSpecific($_)
 }
 #set the new ACL
 Set-Acl -path $using:newpath -AclObject $acl 
 
 #verify
 (Get-ACL $using:newPath).Access
}

Invoke-Command -scriptblock $sb -Session $remote

#grant SALES Users modify
$sb = {
 $acl = Get-ACL -Path $using:newpath
 
 [System.Security.Principal.NTAccount]$principal="globomantics\Chicago Sales Users"
 $Right="Modify"
 $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($Principal,$Right,"Allow")
 $rule
 $acl.SetAccessRule($rule)
 Set-Acl -path $using:newpath -AclObject $acl
}

Invoke-Command -scriptblock $sb -Session $remote

#verify
Invoke-command {(Get-ACL $using:newPath).Access} -session $remote

#endregion

#region Create file share

help New-SmbShare -ShowWindow

#create a new CIM Session for the file server
$cimsession = New-CimSession -ComputerName $FS

$shareParams = @{
 Name = "SalesData"
 Path = $newpath
 Description = "Chicago Sales Data"
 FullAccess = "globomantics\Domain Admins"
 ChangeAccess = "globomantics\chicago sales users"
 CachingMode = "Documents"
 CIMSession = $cimsession
}

New-SmbShare @shareparams

#verify
Get-SmbShare -CimSession $cimsession

Get-SmbShareAccess -Name SalesData -CimSession $cimsession |
format-list

<#
 use Set-SMBShare to modify
 or Remove-SMBShare to remove it
 Remove-SMBShare SalesData -cimsession $cimsession
#>

#endregion

New-PSDrive "SalesData" filesystem "\\chi-fp02\salesdata"
dir salesData:
