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



VERBOSE: 2018-08-02T12:46:53.7559393Z Processing ConvertToMvmcVirtualHardDiskCommand

VERBOSE: 2018-08-02T12:46:53.7804170Z powershell_ise, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35

VERBOSE: 2018-08-02T12:46:54.0503366Z Opening drive to be converted E:\Win10vDiskVmdkToVhdx\Public Workstation.vmdk.

VERBOSE: 2018-08-02T12:46:54.0513399Z An exception of type Microsoft.Accelerators.Mvmc.Engine.VmdkDescriptorParseException has occurred
Exception:   Microsoft.Accelerators.Mvmc.Engine.VmdkDescriptorParseException: The entry 1 is not a supported disk database entry for the descriptor.
   at Microsoft.Accelerators.Mvmc.Engine.Drive.Vmdk.DescriptorParser.ParseDdbEntry(IDescriptor descriptor, Match match)
   at Microsoft.Accelerators.Mvmc.Engine.Drive.Vmdk.DescriptorParser.Parse(String descriptorText)
   at Microsoft.Accelerators.Mvmc.Engine.Drive.VMwareDiskLocator.GetFileTypeForFile(FileInfo fileInfo, TaskContext taskContext)
   at Microsoft.Accelerators.Mvmc.Engine.Drive.DriveFactory.OpenVmdk(String path, TaskContext taskContext)
   at Microsoft.Accelerators.Mvmc.Engine.ServiceLayer.DriveConversionService.ConvertVmdkToVhd(String vmdkDrivePath, String vhdDrivePath, VhdType vhdType, Boolean vhdx, TaskContext taskContext)
   at Microsoft.Accelerators.Mvmc.Engine.ServiceLayer.DriveConversionService.<>c__DisplayClass6.<ConvertVmdkToDynamicVhdxAsync>b__5()
   at System.Threading.Tasks.Task`1.InnerInvoke()
   at System.Threading.Tasks.Task.Execute()

Stack Trace:    at Microsoft.Accelerators.Mvmc.Engine.Drive.Vmdk.DescriptorParser.ParseDdbEntry(IDescriptor descriptor, Match match)
   at Microsoft.Accelerators.Mvmc.Engine.Drive.Vmdk.DescriptorParser.Parse(String descriptorText)
   at Microsoft.Accelerators.Mvmc.Engine.Drive.VMwareDiskLocator.GetFileTypeForFile(FileInfo fileInfo, TaskContext taskContext)
   at Microsoft.Accelerators.Mvmc.Engine.Drive.DriveFactory.OpenVmdk(String path, TaskContext taskContext)
   at Microsoft.Accelerators.Mvmc.Engine.ServiceLayer.DriveConversionService.ConvertVmdkToVhd(String vmdkDrivePath, String vhdDrivePath, VhdType vhdType, Boolean vhdx, TaskContext taskContext)
   at Microsoft.Accelerators.Mvmc.Engine.ServiceLayer.DriveConversionService.<>c__DisplayClass6.<ConvertVmdkToDynamicVhdxAsync>b__5()
   at System.Threading.Tasks.Task`1.InnerInvoke()
   at System.Threading.Tasks.Task.Execute()

WARNING: Fail with exception:  The entry 1 is not a supported disk database entry for the descriptor.
 
