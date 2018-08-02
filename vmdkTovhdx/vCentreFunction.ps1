###Method 2 - Convert VMDK to VHDX###
#After the TS is completed, machine VM poweroff start capturing vDisk
#Destination path e.g $DestVhdxPath = "E:\Win10vDiskVmdkToVhdx"

Function Convert-VmdkToVhdx{
    [CmdletBinding()]
    param([Parameter(Mandatory=$true)][string]$vmName,   
          [Parameter(Mandatory=$true)][string]$DestVhdxPath
    )


    Function Show-ExceptionType{

        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [System.Exception]$Exception
        )

        $indent = 0
        $e= $Exception

        while($e) {
            Write-Host ("{0,$indent}{1}" -f '' , $e.GetType().FullName)

            $indent +=2
            $e = $e.InnerException
        }
        return $e
    }


    #Check for VMK file path e.g "E:\Vmware\Win10\Windows 10 x64.vmdk"
    #Check for destination folder E:\Win10vDiskVmdkToVhdx
    
    Try{
       

        #$DestVhdxPath = "E:\Win10vDiskVmdkToVhdx"
        #$vmName = "WIN10PVSVDI-01"
        #$vmName = "Public Workstation"

        #read-host -assecurestring | convertfrom-securestring | out-file F:\scripts\Credential\cred.txt
        $pass = get-content F:\scripts\Credential\cred.txt | convertto-securestring
        $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist "administrator@vsphere.local",$pass

        #for powerCLI 6.5
        Import-Module vmware.vimautomation.core

        $oldverbose = $VerbosePreference
        $VerbosePreference = "continue"

        #$cred= Get-Credential administrator@vsphere.local
        Connect-VIServer vcentre -cred $cred
        $vm = get-vm -name $vmName
        Write-Verbose("vmname: $vm")
        #$vms|select *|ft
        if ($vm.PowerState -eq "PoweredOff"){

            $disks=get-vm $vm |get-harddisk|select -expand Filename
            $count=$disks.count

                
            $disk=$disks
            
            $ds=($disk -split "\s+")[0]
            $filePath=$disk.Replace("$ds ",'')
            Write-Verbose("File Path: " + $filePath)
            #$filePath=$filePath.Replace(".vmdk","-flat.vmdk")
            $vmdkFile=$filePath.split("/")[1]
            $ds=$ds.trimend("]").trimstart("[")
            Write-Verbose("Datastore: " + $ds)
                
            #Create a PSDrive to grab the vmdk from
            Remove-PSDrive -Name vDS -erroraction silentlycontinue
            new-psdrive -name vDS -location (get-datastore $ds) -psprovider vimdatastore -root '/' |out-null
            #new-psdrive -name vDS -location (get-datastore $ds) -psprovider vimdatastore -root '\' -location $ds[0]  
            #new-psdrive -name vDS -location (get-datastore $ds) -psprovider vimdatastore -root '\' -location $ds[1]  

            
                
            if ($vmdkFile -and $filePath){

                #copy vmdk file to local
                Write-Verbose("copy-datastoreitem")
                #copy-datastoreitem -item vDS:$filePath $DestVhdxPath -force -Verbose -ErrorAction stop

                #Convert vmdk to vhdx
                Write-Verbose("ConvertTo-MvmcVirtualHardDisk")
                Import-Module 'C:\Program Files\Microsoft Virtual Machine Converter\MvmcCmdlet.psd1'
                $SourcePathVmdkFile = "$DestVhdxPath\$vmdkFile"
                ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath $SourcePathVmdkFile -VhdType DynamicHardDisk -VhdFormat vhdx -destination $DestVhdxPath -ErrorAction Stop  
            }
                
        }else{
            
            Write-Host "Please power off $vmName before conversion start"
        }          


    }Catch [Microsoft.Accelerators.Mvmc.Engine.VmdkDescriptorParseException]{

        try{
              
            #OK, 1024 bytes, 0.000s, MD5 = 665927376f2206ecd0a0b9bf807ef930
            #remove-item F:\dsfok\descriptor.txt
            #$errorActionPreference = 'Stop'
            $SourcePathVmdkFile = 'E:\Win10vDiskVmdkToVhdx\Public Workstation.vmdk'
            remove-item F:\dsfok\descriptor4.txt
            Invoke-Expression -Command 'F:\dsfok\dsfo.exe "E:\Win10vDiskVmdkToVhdx\WIN10PVSVDI-01.vmdk" 512 1024 descriptor4.txt'
            #$errorActionPreference = 'Continue'

            $exerun = $?

            if ($exerun -eq $true) {

                #OK, written 1024 bytes at offset 512

                $rc1 = Get-ChildItem Get-Content F:\dsfok\descriptor4.txt| Select-String -pattern "ddb.toolsInstallType"
                if ($rc1){
                    (Get-Content F:\dsfok\descriptor4.txt).replace('ddb.toolsInstallType', '#ddb.toolsInstallType') | Set-Content F:\dsfok\descriptor4.txt
                    $dsfi = & 'F:\dsfok\dsfi.exe" '$SourcePathVmdkFile' 512 1024 descriptor.txt' -errorAction stop
                    $rc = ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath $SourceVmdkFile -VhdType DynamicHardDisk -VhdFormat vhdx -destination $DestVhdxPath          
                    if (!$?){
                        Write-Warning "Failed to convert disk data from $($SourceVmdkFile.toUpper())"
                    }
                }else{
                    write-host "'ddb.toolsInstallType' not found, please try with different vmdk file"
                }
            }

            # Import-Module 'C:\Program Files\Microsoft Virtual Machine Converter\MvmcCmdlet.psd1'
            # mcli.exe add DiskLocator -r diskLocatorName=Win10vDiskVmdkToVhdx,siteName=Win10vDiskVmdkToVhdx,storeName=Automation,serverName=pvc-01.redink.com
            #remove-item F:\dsfok\descriptor.txt
        }catch{
            Write-Warning ("vDisk Conversion Failed with exception: $getExceptionType $($_.Exception.message)")
            write-host "Could not perform the vDisk conversion, make sure you have dsfok installed"
            write-host "Pease ensure that "ddb.toolsInstallType" is commented it out in descriptor1.txt"
            write-host "If 'ddb.toolsInstallType' is not found then for another vmdk file; there could be a potential issue with vmdk file"

        }

    }finally{

        Remove-PSDrive -Name vDS -erroraction silentlycontinue
        $VerbosePreference = $oldverbose

    }

}


Convert-VmdkToVhdx -vmName "Public Workstation" -DestVhdxPath E:\Win10vDiskVmdkToVhdx
