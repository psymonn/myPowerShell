ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath "vDS1:Public Workstation.vmdk" -VhdType DynamicHardDisk -VhdFormat vhdx -destination "vDS1:\WIN10PVSVDI-01" -ErrorAction Stop  
ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath "vmstores:\172.17.5.140@443\Datacenter\datastore1\WIN10PVSVDI-01\IN10PVSVDI-01.vmdk" -VhdType DynamicHardDisk -VhdFormat vhdx -destination "Microsoft.PowerShell.Core\FileSystem::\\172.17.5.166\nfs_pvs1" -ErrorAction Stop  
ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath "vDS:\Public Workstation\Public Workstation.vmdk" -VhdType DynamicHardDisk -VhdFormat vhdx -destination $DestVhdxPath -ErrorAction Stop

copy-datastoreitem -item vDS:"Public Workstation-flat.vmdk" E:\Win10vDiskVmdkToVhdx -force -Verbose 
copy-datastoreitem -item "vmstore:\Datacenter\datastore1\WIN10PVSVDI-01\WIN10PVSVDI-01-flat.vmdk" E:\Win10vDiskVmdkToVhdx -force -Verbose                 

Remove-PSDrive -Name vDS1 -erroraction silentlycontinue
new-psdrive -name vDS1 -location (get-datastore $ds) -psprovider vimdatastore -root '/' |out-null
Get-PSDrive
#vmstores:\ViServer1\Datacenter1\Datastore1\My WinXP\My WinXP.vmx
$vmdkFile = get-item vds:\$vmName\$file
$vmdkFile = "$vmName\$file"
$filePath= $vmdkFile.
$providerPath= (get-location $vmdkFile).CountProviderPath
Get-ChildItem -Path $vmdkFile | Select DatastoreFullPath,LastWriteTime |fl

ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath "$DestVhdxPath\$vmdk" -VhdType DynamicHardDisk -VhdFormat vhdx -destination $DestVhdxPath -ErrorAction Stop  
                #ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath "vmstores:\172.17.5.140@443\Datacenter\datastore1\WIN10PVSVDI-01\IN10PVSVDI-01.vmdk" -VhdType DynamicHardDisk -VhdFormat vhdx -destination "Microsoft.PowerShell.Core\FileSystem::\\172.17.5.166\nfs_pvs1" -ErrorAction Stop  
                #ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath "vDS:\Public Workstation\Public Workstation.vmdk" -VhdType DynamicHardDisk -VhdFormat vhdx -destination $DestVhdxPath -ErrorAction Stop


read-host -assecurestring | convertfrom-securestring | out-file F:\scripts\Credential\cred.txt

Once we have our password safely stored away, we can draw it back into our scripts..

$password = get-content F:\scripts\Credential\cred.txt | convertto-securestring

Then finally, we can create our credential object, which we pump into other cmdlets.

$credentials = new-object -typename System.Management.Automation.PSCredential -argumentlist "myusername",$pass


 C:\> Get-Datastore datastore1

Name                               FreeSpaceGB      CapacityGB
----                               -----------      ----------
datastore1                              18.573         142.500
datastore1                              18.573         142.500