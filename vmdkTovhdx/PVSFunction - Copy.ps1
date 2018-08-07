Function Import-VdiskToPVS {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,
                   Position=0)]
        [String]$ComputerName,    #pvc-01
        [String]$vdiskFile,       #"Win13"
        [String]$CollectionName,  #"Automation"
        [String]$PVSStore,        #"Automation"
        [String]$siteName,       #"Chicago"
        [String]$deviceName,      #"WIN10PVS-01"
        [String]$deviceMac       # 00-00-00-00-00-00
       # [AllowNull()][int]$Newest
    )

   Function Check-PvsError{
   <#
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [System.Exception]
            $Exception
        )
      #> 
       if ($error[0].CategoryInfo.Reason -eq "PvsException"){
          if ($error[0].Exception -notmatch "xml: vDisk file was not found") {
                Write-Error -Exception ([Exception]::new("$error[0].Exception `n $($error[0].CategoryInfo | select TargetName)")) -ErrorAction Stop
          }
         # $error.Clear()
          #return true
       }

       
   }


    #pvs server test
    if (Test-Connection $ComputerName -Quiet -Count 2) {

        Try{
            #read-host -assecurestring | convertfrom-securestring | out-file c:\scripts\Credential\PVScred.txt
            $pass = get-content 'C:\scripts\Credential\PVScred.txt' | convertto-securestring
            $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist "redink\administrator",$pass
            if ($ssl) {
                $option = New-PSSessionOption -SkipCNCheck
                $pvs = New-PSSession -computerName pvc-01 -SessionOption $option -Credential $cred -usessl
                #$pvs = New-PSSession -computerName pvc-01 -SessionOption $option -Credential redink\administrator -usessl
             }else{
                #$pvs = New-PSSession -ComputerName pvc-01.redink.com -Credential (Get-Credential)
                #$pvs = New-PSSession -ComputerName pvc-01 -Credential redink\administrator
                $pvs = New-PSSession -ComputerName pvc-01 -Credential $cred
             }

            try{
                Invoke-Command -Session $pvs -ScriptBlock {Import-Module "C:\Program Files\Citrix\Provisioning Services Console\Citrix.PVS.SnapIn.dll"}
                Import-PSSession -Session $pvs -Prefix WRK -Module Citrix.PVS.SnapIn
            }catch{
                Write-Warning ("Proxy creation has been triggered because this moudle already loaded from different session : $getExceptionType $($_.Exception.message)")
                Import-PSSession -Session $pvs -Prefix WRK -Module Citrix.PVS.SnapIn -AllowClobber
            }

            #$ErrorActionPreference = "stop"
            $error.Clear()
            #From PVS server
            #Choose a store e.g Staging (vDisk versioning can be view here)
            $wrkPVSStore=(Get-WRKPvsStoreSharedOrServerPath -ServerName $ComputerName -SiteName $siteName|Where-Object{$_.StoreName -eq $PVSStore})
            $store=$wrkPVSStore.StoreName

            #Create meta data for the new vDisk, it would overwrite existing one - good things ofcourse.
            $newPvsLocator = New-WRKPvsDiskLocator -Name $vdiskFile -StoreName Automation -ServerName $ComputerName -SiteName chicago -VHDX -errorAction stop
            
           #  $error.Count
          #   $targetNameInfo = $error[0].CategoryInfo | select TargetName
           #  $error[0].FullyQualifiedErrorId
            # $ExceptionMessage = $error[0].Exception
            Check-PvsError
             
             <#
             if ($error[0].CategoryInfo.Reason -eq "PvsException"){
                  Write-Error -Exception ([Exception]::new("$error[0].Exception $($error[0].CategoryInfo | select TargetName)")) -ErrorAction Stop
             }

             #>
            #Add or Import Existing vDisk; search for vDisk; choose the vDisk and Select Add
            #You must bein VHDX otherwise PVP file will not be created.
            Import-WRKPvsDisk -DiskLocatorName $newPvsLocator.Name -StoreName $store -SiteName $siteName -ServerName $ComputerName -Enabled -VHDX -errorAction stop
            Check-PvsError

            #Choose Device Collection e.g Staging
            #Create a new Target Device give it a name; allocate mac address; type: Test; Boot from: vDisk; Port: 6901
            New-WRKPvsDevice -SiteName $siteName  -CollectionName $CollectionName -DeviceName $deviceName -DeviceMac $deviceMac
            Check-PvsError

            #Add vDisks to this devices \\cifs-siepd21nft3020.dpesit.protectedsit.mil.au\siepd21pvt10_stage01\Staging\WIN10-vDisk-PVS-01.vhdx
           # Add-WRKPvsDiskLocatorToDevice -Name $vdiskFile -CollectionName $CollectionName -SiteName $siteName -StoreName $store -DeviceName $deviceName
            Add-WRKPvsDiskLocatorToDevice -SiteName $siteName -StoreName $store -DiskLocatorName $vdiskFile -DeviceName $deviceName -CollectionName $CollectionName
            Check-PvsError

            Write-Host "NEW vDisk has been succesfully Imported and assigned to NEW Target Device."

          }Catch{
             Write-Warning ("Failed at vDisk Captured: `n $($_.Exception.message)")
             
          }finally{
            Remove-PSSession -ID $pvs.ID
            #$ErrorActionPreference = "Continue"
            #Get-PSSession | Remove-PSSession
          }
    }else{

       Write-Host "PVS Server $ComputerName not found"
    }

}

Import-VdiskToPVS -computername pvc-01 -vdiskFile win14  -CollectionName Automation -PVSStore Automation -siteName Chicago -deviceName "WIN10PVS-03" -deviceMac "00-00-00-00-00-03"
#Get-PVSDeviceInfo |select SiteName, DiskLocatorName , diskversion, devicename, Collectionname  |ft
#Get-PvsDiskLocator -SiteName $sitename -StoreName $store -DiskLocatorName $vdiskFile
