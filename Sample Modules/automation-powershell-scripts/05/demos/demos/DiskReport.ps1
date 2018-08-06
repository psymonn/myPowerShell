#run the daily disk report

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

#save the results to a text file report

<#
 $header is a here string. This is a great way
 to create a multi-line string. The closing "@
 must be left justified
#>

$header = @"
Disk History Report $((Get-Date).ToShortDateString())
******************************
Data Source = $Path

*************
Latest Check
*************
"@

#get a timestamp value. -Format value is case-sensitive
$timestamp = Get-Date -format yyyyMMdd
$OutputFile = "$timestamp-diskreport.txt"
$OutputPath = Join-Path -path $ReportPath -ChildPath $OutputFile

#define a hashtable of parameters for Out-File.
#this will be splatted.
$outParams = @{
    FilePath = $OutputPath
    Encoding = "ASCII"
    Append   = $True
    Width    = 120
}

#splat the parameter hashtable
$header | Out-File @outParams

#get the last entry for each computer

$latest = foreach ($computer in $grouped) {
    #need to report for each deviceID on each computer
    $devices = $computer.Group  | Group-Object -Property DeviceID
    $devices | foreach-object {
        $_.Group | Sort-Object Date -Descending |  Select-object -first 1
    }
}

#normally you wouldn't use Format cmdlets in a script. This is
#an exception because I want nicely formatted output in the text file.
$latest | Sort-Object -property Computername |
    Format-Table -AutoSize | Out-file @outParams

#report on servers with low disk space
$header = @"
*******************
Low Diskpace <=30%
*******************
"@

$header | Out-File @outParams
$latest | Where-Object {$_.PctFree -le 30} |
    Sort-Object -Property Computername |
    Format-Table -AutoSize |
    Out-File @outParams

#report trending
#need to report for each deviceID on each computer
#group the data by a custom property. This may be a little advanced.
$all = $data | Group-object -property {"$($_.Computername) $($_.DeviceID)"}

$header = @"
**************************************
Change Percent between last 2 reports
**************************************
"@
$header | Out-File @outParams

$all | ForEach-Object {
    #get the 2 most recent entries for each device
    $checks = $_.group |
    Sort-Object -Property date -Descending |
        Select-Object -first 2

    #calculate a percent change between the two entries
    "$($checks[0].Computername) Drive $($checks[0].DeviceID) had a change of $(($checks[0].PctFree - $checks[1].PctFree) -as [int32])%"
} | Out-File @outParams

$header = @"


*******************************
Percent Free Average Over Time
*******************************
"@
$header | Out-File @outParams

foreach ($computer in $all) {
    $stat = $computer.group | Measure-Object -property pctFree -Average
    "$($computer.name) = $($stat.Average -as [int32])%" | Out-File @outParams
}

#write the report file to the pipeline
Get-Item -Path $OutputPath

#sample usage
# .\DiskReport
# open file to view
