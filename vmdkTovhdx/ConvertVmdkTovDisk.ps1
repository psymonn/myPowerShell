https://stackoverflow.com/questions/37481737/error-when-converting-vmware-virtual-disk-to-hyperv
download: https://www.microsoft.com/en-us/download/details.aspx?id=42497
mvmc_setup.msi and dsfok

Import-Module 'C:\Program Files\Microsoft Virtual Machine Converter\MvmcCmdlet.psd1'

PS C:\> ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath "E:\Vmware\Win10\Windows 10 x64.vmdk" -VhdType DynamicHardDisk -VhdFormat vhdx -destination E:\Win10vDiskVmdkToVhdx
ConvertTo-MvmcVirtualHardDisk : Local administrator privileges are required.
At line:1 char:1
+ ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath "E:\Vmware\Win10\Win ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : WriteError: (Microsoft.Accel...nversionService:DriveConversionService) [ConvertTo-MvmcVirtualHardDisk], SecurityException
    + FullyQualifiedErrorId : DiskConversion,Microsoft.Accelerators.Mvmc.Cmdlet.Commands.ConvertToMvmcVirtualHardDiskCommand
 
ConvertTo-MvmcVirtualHardDisk : One or more errors occurred.
At line:1 char:1
+ ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath "E:\Vmware\Win10\Win ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : WriteError: (Microsoft.Accel...nversionService:DriveConversionService) [ConvertTo-MvmcVirtualHardDisk], AggregateException
    + FullyQualifiedErrorId : DiskConversion,Microsoft.Accelerators.Mvmc.Cmdlet.Commands.ConvertToMvmcVirtualHardDiskCommand

PS F:\dsfok> ./dsfo.exe "E:\Vmware\Win10\Windows 10 x64.vmdk" 512 1024 descriptor1.txt
OK, 1024 bytes, 0.000s, MD5 = 665927376f2206ecd0a0b9bf807ef930
PS F:\dsfok> ./dsfi.exe "E:\Vmware\Win10\Windows 10 x64.vmdk" 512 1024 descriptor1.txt
OK, written 1024 bytes at offset 512

PS F:\dsfok> ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath "E:\Vmware\Win10\Windows 10 x64.vmdk" -VhdType DynamicHardDisk -VhdFormat vhdx -destination E:\Win10vDiskVmdkToVhdx\

Destination                                 Source
-----------                                 ------
E:\Win10vDiskVmdkToVhdx\Windows 10 x64.vhdx E:\Vmware\Win10\Windows 10 x64.vmdk
