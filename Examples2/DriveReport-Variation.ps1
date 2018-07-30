#requires -version 5.0
#requires -module Storage

<#
This is a variation of the DiskReport.ps1 script that
creates a custom object instead of using Select-Object
#>

Param(
    [string[]]$Computername = $env:COMPUTERNAME
)

foreach ($computer in $Computername) {
    #verify computer is online
    if (Test-Connection -ComputerName $Computer -Count 2 -Quiet) {

        #get all volumes that have a DriveLetter assigned
        Try {
            Write-Host "Getting volume data from $($computer.toUpper())" -ForegroundColor Cyan
            $volumes = Get-Volume -CimSession $computer -ErrorAction Stop | 
                Where-Object {$_.DriveLetter} | 
                Sort-Object -Property DriveLetter
        
            #create a custom object for each volume object
            foreach ($volume in $volumes) {
                [PSCustomObject]@{
                    Computername = $volume.PSComputername.ToUpper()
                    Drive        = $volume.DriveLetter
                    FileSystem   = $volume.FileSystem
                    SizeGB       = $volume.size / 1gb -as [int32]        
                    FreeGB       = [math]::Round($volume.SizeRemaining / 1gb, 2)
                    PctFree      = [math]::Round(($volume.SizeRemaining / $volume.size) * 100, 2)
                }
            } #foreach volume 
        } #Try
        Catch {
            Write-Warning "Can't get volume data from $($Computer.ToUpper()). $($_.Exception.Message)."
        }
    } #if test is ok
    else {
        Write-Warning "Can't ping $($Computer.ToUpper())."
    }
} #foreach computer