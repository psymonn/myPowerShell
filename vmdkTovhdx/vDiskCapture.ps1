Import-Module “C:\Program Files\Citrix\Provisioning Services Console\Citrix.PVS.SnapIn.dll”
Import-Module 'C:\Program Files\Microsoft Virtual Machine Converter\MvmcCmdlet.psd1'

Function Convert-ToVhdx {
    ####Method 1 - Imaging Wizard###
    #From Desktop (while running TS)
    #Using the Provisioning Services Imaging Wizard
    #Select Provisioning server 172.17.5.166
    #Create an image file make an image file from this device's booted disk, for importing into Provisioning Services.
    #Choose location e.g \\cifs-siepd21nft3020.dpesit.protectedsit.mil.au\siepd21pvt10_stage01\Staging\WIN10-vDisk-PVS-01.vhdx
    #Select image entire boot disk, Select Optimisation the hardisk for provisioning services before imaging; Select Create
}


###Method 2 - Convert VMDK to VHDX###
#After the TS is completed, machine VM poweroff start capturing vDisk
Function Convert-VmdkToVhdx{
    [CmdletBinding()]
    param (
        [string]$SourceVmdkFile,     
        [string]$DestVhdxPath    
    )

    #Check for VMK file path e.g "E:\Vmware\Win10\Windows 10 x64.vmdk"
    #Check for destination folder E:\Win10vDiskVmdkToVhdx
    If (($SourceVmdkFile) -and ($DestVhdxPath)){

        Try{
        
            ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath $SourceVmdkFile -VhdType DynamicHardDisk -VhdFormat vhdx -destination $DestVhdxPath -ErrorAction Stop           

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

#Import vDisk to PVS
Fuction Import-VdiskToPVS {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [String]$ComputerName,

        [string]$DestVhdxFile,

        [string]$CollectionName,

        [AllowNull()]
        [int]$Newest
    )

    
    Function ConvertSID
    {
        param (
            [string]$SID
        )

        if ($SID)
        {
            $userSID = New-Object -TypeName System.Security.Principal.SecurityIdentifier -ArgumentList $SID
            $UserName = ($userSID.Translate( [System.Security.Principal.NTAccount])).value
            $UserName
        }
    }

    if (Test-Connection -ComputerName $ComputerName)
    {
        
        Try{

                Invoke-Command -ComputerName $ComputerName -Credential (Get-Credential) -ScriptBlock {

                #From PVS server
                #Choose a store e.g Staging (vDisk versioning can be view here)
                $store=Get-PvsStoreSharedOrServerPath -ServerName siepd21pvt1001 -SiteName D21A_0|Where-Object{$_.StoreName -eq 'Staging'}

                #Add or Import Existing vDisk; search for vDisk; choose the vDisk and Select Add
                Import-PvsDisk -DiskLocatorName $DestVhdxFile  -StoreName $store -SiteName D21A_0 -ServerName siepd21pvt1001 -VHDX 

                #Choose Device Collection e.g Staging
                #Create a new Target Device give it a name; allocate mac address; type: Test; Boot from: vDisk; Port: 6901 
                New-PvsDevice -SiteName D21A_0  -CollectionName $CollectionName -DeviceName WIN10PVS-01 -DeviceMac “00-00-00-00-00-00”

                #Add vDisks for this devices \\cifs-siepd21nft3020.dpesit.protectedsit.mil.au\siepd21pvt10_stage01\Staging\WIN10-vDisk-PVS-01.vhdx
                Add-PvsDiskLocatorToDevice -Name $DestVhdxFile -CollectionName $CollectionName -SiteName theSite -StoreName $store


                }

          }Catch{

             Write-Warning "Failed at vDisk Captured"
          }
    }


   
}






#############
#Ref
#############
#Add an existing vDisk to PVS Store:
New-PvsDiskLocator -Name “YourDiskName” -StoreName “YourStoreName” -ServerName “YourPVSServerName” -SiteName “YourSiteName” -VHDX

#Change vDisk mode:
Set-PvsDisk -Name “YourDiskName” -StoreName “YourStoreName” -SiteName “YourSiteName” -WriteCacheType “9” -WriteCacheSize “SizeInMB”


#Add an existing vDisk to PVS Store:
#Format 1 is VHDX 0 is VHD
New-PvsDiskLocator -Name “YourDiskName” -StoreName “YourStoreName” -ServerName “YourPVSServerName” -SiteName “YourSiteName” -VHDX

#Change vDisk licensing type:
Set-PvsDisk -DiskLocatorName “YourDiskName” -StoreName “YourStoreName” -SiteName “YourSiteName” -LicenseMode “2”

#Create a new device collection:
New-PvsCollection -SiteName “YourSiteName” – CollectionName “NewCollectionName”

#Create a new device:
New-PvsDevice -SiteName “YourSiteName”  -CollectionName “NewCollectionName” -DeviceName “NewDevice” -DeviceMac “00-00-00-00-00-00”

#Assign vDisk to a collection:
Add-PvsDiskLocatorToDevice -SiteName “YourSiteName” -StoreName “YourStoreName” -DiskLocatorName “YourDiskName” -CollectionName “NewCollectionName” -RemoveExisting


#https://blogs.msdn.microsoft.com/timomta/2015/06/11/how-to-convert-a-vmware-vmdk-to-hyper-v-vhd/
#How to Convert a VMWare VMDK to Hyper-V VHD
#Import-Module 'C:\Program Files\Microsoft Virtual Machine Converter\MvmcCmdlet.psd1'
ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath d:\scratch\vmx\VM-disk1.vmdk -VhdType DynamicHardDisk -VhdFormat vhdx -destination c:\vm-disk1