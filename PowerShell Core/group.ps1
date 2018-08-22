$all = $data | Group-object -property {"$($_.Computername) $($_.DeviceID)"}

if (Test-Path -path $Path) {
    #everything imported into a CSV is a string so rebuild as an object
    #with properties of the correct type
    $data = Import-CSV -Path $path | foreach-object {
        [pscustomobject]@{
            Computername = $_.Computername
            DeviceID     = $_.DeviceID
            SizeGB       = ($_.size / 1GB) -as [int32]
            FreeGB       = ($_.freespace / 1GB)
            PctFree      = $_.PctFree -as [double]
            Date         = $_.Date -as [datetime]
        }
    }
    #group the history data by computername
    $grouped = $data | Group-Object -Property Computername
}


