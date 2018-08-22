
Param (
    [string]$Path = "D:\Studying\PLURALSIGHT Courses\automation-powershell-scripts\05\demos\demos\DiskHistory.csv",
    [string]$ReportPath = "D:\Studying\PLURALSIGHT Courses\automation-powershell-scripts\05\demos\demos"
)

#import CSV data
#verify the file exists
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
else {
    #if Test-Path fails, display a warning and exit the script
    Write-Warning "Can't find $Path."
    #bail out of the script
    Return
}


$wsh = new-object -com wscript.shell
$wsh.Popup.OverloadDefinitions
$wsh.Popup("Isn't this fun?",10,"PowerShell Automation",0+64)
$wsh.Popup("Failed to do something. Do you want to try again?",-1,"Script Error",4+32)

$host.ui.RawUI.WindowTitle
$saved = $host.ui.RawUI.WindowTitle
"dom1","srv1","srv2","win10" | 
foreach-object {
  $host.ui.RawUI.Windowtitle = "Querying uptime from $($_.toUpper())"
  #add an artificial pause for the sake of demonstration
  start-sleep -Seconds 2
  Get-CimInstance Win32_OperatingSystem -computername $_ | 
  Select PSComputername,LastBootUpTime,
  @{Name="Uptime";Expression={(Get-Date) - $_.LastBootUpTime}}
}

$host.ui.RawUI.Windowtitle = $saved

