Fuction Import-VdiskToPVS {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [String]$ComputerName,

        [string]$vdiskFile,

        [string]$CollectionName,

        [string]$PVSStore,

        [AllowNull()]
        [int]$Newest
    )

    #private function
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

    #pvs server test
     $ComputerName = "pvc-01"
    if (Test-Connection -ComputerName $ComputerName)
    {

        Try{

            $pvs = New-PSSession -ComputerName pvc-01.redink.com -Credential (Get-Credential)
            Invoke-Command -Session $pvs -ScriptBlock {Import-Module “C:\Program Files\Citrix\Provisioning Services Console\Citrix.PVS.SnapIn.dll”}
            Import-PSSession -Session $pvs -Module “Citrix.PVS.SnapIn”

            
            $vdiskFile="Win13"
            $CollectionName = "Automation"
            $siteName = "Chicago"
            $PVSStore = "Automation"
            $deviceName = "WIN10PVS-01"
            $deviceMac = “00-00-00-00-00-00”

            #From PVS server
            #Choose a store e.g Staging (vDisk versioning can be view here)
            $wrkPVSStore=(Get-PvsStoreSharedOrServerPath -ServerName $ComputerName -SiteName $siteName|Where-Object{$_.StoreName -eq $PVSStore})
            $store=$wrkPVSStore.StoreName

            #Create meta data for the new vDisk
            $newPvsLocator = New-PvsDiskLocator -Name $vdiskFile -StoreName “Automation” -ServerName $ComputerName -SiteName “chicago” -VHDX

            #Add or Import Existing vDisk; search for vDisk; choose the vDisk and Select Add
            #You must bein VHDX otherwise PVP file will not be created.
            Import-PvsDisk -DiskLocatorName $newPvsLocator.Name -StoreName $store -SiteName $siteName -ServerName $ComputerName -Enabled -VHDX

            #Choose Device Collection e.g Staging
            #Create a new Target Device give it a name; allocate mac address; type: Test; Boot from: vDisk; Port: 6901
            New-PvsDevice -SiteName $siteName  -CollectionName $CollectionName -DeviceName $deviceName -DeviceMac $deviceMac

            #Add vDisks for this devices \\cifs-siepd21nft3020.dpesit.protectedsit.mil.au\siepd21pvt10_stage01\Staging\WIN10-vDisk-PVS-01.vhdx
            Add-PvsDiskLocatorToDevice -Name $vdiskFile -CollectionName $CollectionName -SiteName $siteName -StoreName $store

          }Catch{

             Write-Warning "Failed at vDisk Captured"
          }
    }else{

       Write-Host "PVS Server $ComputerName not found"
    }



}


#Get-PVSDeviceInfo |select SiteName, DiskLocatorName , diskversion, devicename, Collectionname  |ft
#Get-PvsDiskLocator -SiteName $sitename -StoreName $store -DiskLocatorName $vdiskFile
