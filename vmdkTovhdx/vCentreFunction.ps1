###Method 2 - Convert VMDK to VHDX###
#After the TS is completed, machine VM poweroff start capturing vDisk
Import-Module 'C:\Program Files\Microsoft Virtual Machine Converter\MvmcCmdlet.psd1'
Function Convert-VmdkToVhdx{
    [CmdletBinding()]
    param (
        [string]$vmName,     
        [string]$DestVhdxPath    
    )

    #Check for VMK file path e.g "E:\Vmware\Win10\Windows 10 x64.vmdk"
    #Check for destination folder E:\Win10vDiskVmdkToVhdx
    If (($SourceVmdkFile) -and ($DestVhdxPath)){

        Try{

            $DestVhdxPath = "E:\Win10vDiskVmdkToVhdx"
            $vmName = "Public Workstation"


            #for powerCLI 6.5
            Import-Module vmware.vimautomation.core
            $cred= Get-Credential administrator@vsphere.local
            Connect-VIServer 172.17.5.140 -cred $cred
            $vm = get-vm -name $vmName
            #$vms|select *|ft
            if ($vms.PowerState -eq "PoweredOff"){

                $disks=get-vm $vm |get-harddisk|select -expand Filename
                $count=$disks.count
                
                $disk=$disks
                $ds=($disk -split "\s+")[0]

                $ds=$ds.trimend("]").trimstart("[")
                $file=($disk -split "/")[1]
                
                #Create a PSDrive to grab the vmdk from
                Remove-PSDrive -Name vDS -erroraction silentlycontinue
                new-psdrive -name vDS -location (get-datastore $ds) -psprovider vimdatastore -root '/' |out-null

                #vmstores:\ViServer1\Datacenter1\Datastore1\My WinXP\My WinXP.vmx
                $vmdkFile = get-item vds:\$vmName\$file
                $vmdkFile = "vds:\$vmName\$file"
                if ($vmdkFile.name -eq $file){
                    #Convert vmdk to vhdx
                    ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath "vDS:\Public Workstation\Public Workstation.vmdk" -VhdType DynamicHardDisk -VhdFormat vhdx -destination $DestVhdxPath -ErrorAction Stop  
                }
                
            }          

        }Catch {

            Write-Warning "Failed to get disk data from $($SourceVmdkFile.toUpper()). $($_.Exception.message)"
            #OK, 1024 bytes, 0.000s, MD5 = 665927376f2206ecd0a0b9bf807ef930
            $dsfo = & "dsfo.exe $SourceVmdkFile 512 1024 descriptor1.txt" /show
            $exerun = $?

            if ($exerun -eq $true) {

                #OK, written 1024 bytes at offset 512
                $dsfi = & "dsfi.exe $SourceVmdkFile 512 1024 descriptor1.txt"
                $rc = ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath $SourceVmdkFile -VhdType DynamicHardDisk -VhdFormat vhdx -destination $DestVhdxPath          
                if (!$?){
                    Write-Warning "Failed to convert disk data from $($SourceVmdkFile.toUpper())"
                }

            }

            Import-Module 'C:\Program Files\Microsoft Virtual Machine Converter\MvmcCmdlet.psd1'
            mcli.exe add DiskLocator -r diskLocatorName=Win10vDiskVmdkToVhdx,siteName=Win10vDiskVmdkToVhdx,storeName=Automation,serverName=pvc-01.redink.com

        }

    }

}