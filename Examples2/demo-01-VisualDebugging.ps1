function Get-ItemInfo ($Path) {
    
    $itemProperties = Get-ChildItem -Path $Path | Select-Object Name,FullName,CreationTime,LastWriteTime
    
    $owner = (Get-Acl -Path $path).Owner

   # $enable = (Get-LocalUser -name ($owner -split "\\")[1])| Select-Object enabled
   $enable = (Get-LocalUser -name ($owner -split "\\")[1])
    #Write-Output $enable
    Write-Host $enable

    $result = [PSCustomObject]@{
        Name = $itemProperties.Name
        FullName = $itemProperties.FullName
        CreationTime = $itemProperties.CreationTime
        ModifiedDate = $itemProperties.LastWriteTime
        Owner = $owner
        OwnerEnable = $enable.enabled
    }

    return $result
}