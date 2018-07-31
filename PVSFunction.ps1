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

            $pvs = New-PSSession -ComputerName pvc-01.lab.com -Credential (Get-Credential)
            Invoke-Command -Session $pvs -ScriptBlock {Import-Module ìC:\Program Files\Citrix\Provisioning Services Console\Citrix.PVS.SnapIn.dllî}
            Import-PSSession -Session $pvs -Module ìCitrix.PVS.SnapInî

            #From PVS server
            #Choose a store e.g Staging (vDisk versioning can be view here)
            $PVSStore=(Get-PvsStoreSharedOrServerPath -ServerName pvc-01 -SiteName Chicago|Where-Object{$_.StoreName -eq "Staging"})
            $store=$PVSStore.StoreName
            $vdiskPath=$PVSStore.Path
            $vdiskFile="Win10vDiskWiz-1.vhdx"
            

            #Add or Import Existing vDisk; search for vDisk; choose the vDisk and Select Add
            Import-PvsDisk -name $vdiskFile -StoreName $store -SiteName Chicago -ServerName pvc-01 -VHDX 
            #Import-PvsDisk -Name $xml.BaseName -SiteName $pvssite.Name -StoreName $store.Name -VHDX|Out-Null

            #Choose Device Collection e.g Staging
            #Create a new Target Device give it a name; allocate mac address; type: Test; Boot from: vDisk; Port: 6901
            New-PvsDevice -SiteName D21A_0  -CollectionName $CollectionName -DeviceName WIN10PVS-01 -DeviceMac ‚Äú00-00-00-00-00-00‚Äù

            #Add vDisks for this devices \\cifs-siepd21nft3020.dpesit.protectedsit.mil.au\siepd21pvt10_stage01\Staging\WIN10-vDisk-PVS-01.vhdx
            Add-PvsDiskLocatorToDevice -Name $DestVhdxFile -CollectionName $CollectionName -SiteName theSite -StoreName $store

          }Catch{

             Write-Warning "Failed at vDisk Captured"
          }
    }



}
