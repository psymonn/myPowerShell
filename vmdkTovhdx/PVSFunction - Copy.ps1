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


    #pvs server test
    if (Test-Connection $ComputerName -Quiet -Count 2) {
        Try{
            if ($ssl) {
                #read-host -assecurestring | convertfrom-securestring | out-file F:\scripts\Credential\PVScred.txt
                $pass = get-content F:\scripts\Credential\PVScred.txt | convertto-securestring
                $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist "redink\administrator",$pass
                $option = New-PSSessionOption -SkipCNCheck
                $pvs = New-PSSession -computerName pvc-01 -SessionOption $option -Credential $cred -usessl
                #$pvs = New-PSSession -computerName pvc-01 -SessionOption $option -Credential redink\administrator -usessl
             }else{
                #$pvs = New-PSSession -ComputerName pvc-01.redink.com -Credential (Get-Credential)
                $pvs = New-PSSession -ComputerName pvc-01 -Credential redink\administrator
             }

            try{
                Invoke-Command -Session $pvs -ScriptBlock {Import-Module "C:\Program Files\Citrix\Provisioning Services Console\Citrix.PVS.SnapIn.dll"}
                Import-PSSession -Session $pvs -Module Citrix.PVS.SnapIn
            }catch{

                Write-Warning "Proxy creation has been skipped for the following command"
                Write-Warning ("Proxy creation has been skipped because this moudle already loaded from different session : $getExceptionType $($_.Exception.message)")
                #Remove-PSSession -Session $pvs -Module Citrix.PVS.SnapIn
                Remove-Module Citrix.PVS.SnapIn
                Import-PSSession -Session $pvs -Module Citrix.PVS.SnapIn
            }

            #$ErrorActionPreference = "stop"
            $error.Clear()
            #From PVS server
            #Choose a store e.g Staging (vDisk versioning can be view here)
            $wrkPVSStore=(Get-PvsStoreSharedOrServerPath -ServerName $ComputerName -SiteName $siteName|Where-Object{$_.StoreName -eq $PVSStore})
            $store=$wrkPVSStore.StoreName

            #Create meta data for the new vDisk
            $newPvsLocator = New-PvsDiskLocator -Name $vdiskFile -StoreName Automation -ServerName $ComputerName -SiteName chicago -VHDX -errorAction stop
             
            
             $error.Count
             $targetNameInfo = $error[0].CategoryInfo | select TargetName
             $error[0].FullyQualifiedErrorId
             $error[0].Exception
              $pvsError = @{ 'CategoryInfo' = "$error[0].CategoryInfo";
                            'Exception' = "$error[0].Exception";
                            'FullyQualifiedErrorId' = "$error[0].FullyQualifiedErrorId"
                          }
             if ($error[0]){
                  Write-Error -Message "Could not find path: $path" -Exception ([Exception]::new($pvsError)) -ErrorAction Stop

             }
            #Add or Import Existing vDisk; search for vDisk; choose the vDisk and Select Add
            #You must bein VHDX otherwise PVP file will not be created.
            $importPVSDisk = Import-PvsDisk -DiskLocatorName $newPvsLocator.Name -StoreName $store -SiteName $siteName -ServerName $ComputerName -Enabled -VHDX -errorAction stop

            #Choose Device Collection e.g Staging
            #Create a new Target Device give it a name; allocate mac address; type: Test; Boot from: vDisk; Port: 6901
            $newPVSDevice = New-PvsDevice -SiteName $siteName  -CollectionName $CollectionName -DeviceName $deviceName -DeviceMac $deviceMac

            #Add vDisks for this devices \\cifs-siepd21nft3020.dpesit.protectedsit.mil.au\siepd21pvt10_stage01\Staging\WIN10-vDisk-PVS-01.vhdx
            Add-PvsDiskLocatorToDevice -Name $vdiskFile -CollectionName $CollectionName -SiteName $siteName -StoreName $store

          }Catch{
             Write-Warning ("Failed at vDisk Captured  : $getExceptionType $($_.Exception.message)")
             $_.GetType().FullName
             $_.Exception
             $_.Exception.keys
             $_.InnerException

             
                Write-Output "General excpetion Could not find $path"
                write-host "Caught an exception:" -ForegroundColor Red
                write-host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
                write-host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red
                Write-host $PSItem.ToString()
                Write-Output $PSItem.Exception.FileName
                Show-ExceptionType -Exception $_.Exception


                [hashtable]$ageList = $_.Exception
                #$hash.Keys | % { "key = $_ , value = " + $hash.Item($_) }

                foreach($key in $ageList.keys)
                {
                    $message = '{0} is {1} years old' -f $key, $ageList[$key]
                    Write-Output $message
                }



          }finally{
            Remove-PSSession -ID $pvs.ID
            #$ErrorActionPreference = "Continue"
            #Get-PSSession | Remove-PSSession
          }
    }else{

       Write-Host "PVS Server $ComputerName not found"
    }

}

Import-VdiskToPVS -computername pvc-01 -vdiskFile win14  -CollectionName Automation -PVSStore Automation -siteName Chicago -deviceName "WIN10PVS-01" -deviceMac "00-00-00-00-00-00"
#Get-PVSDeviceInfo |select SiteName, DiskLocatorName , diskversion, devicename, Collectionname  |ft
#Get-PvsDiskLocator -SiteName $sitename -StoreName $store -DiskLocatorName $vdiskFile
