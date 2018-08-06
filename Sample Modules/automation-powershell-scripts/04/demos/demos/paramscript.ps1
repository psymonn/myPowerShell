#get a breakdown of error sources in the System eventlog

Param(
    [string]$Log = "System",
    [string]$Computername = $env:COMPUTERNAME,
    [int32]$Newest = 500,
    [string]$ReportTitle = "Event Log Report",
    [Parameter(Mandatory,HelpMessage = "Enter the path for the HTML file.")]
    [string]$Path
)

#get event log data and group it
$data = Get-Eventlog -logname $Log -EntryType Error -Newest $newest -ComputerName $Computername |
    Group-object -Property Source -NoElement 

#create an HTML report
$footer = "<h5><i>report run $(Get-Date)</i></h5>"
$css = "http://jdhitsolutions.com/sample.css"
$precontent = "<H1>$Computername</H1><H2>Last $newest error sources from $Log</H2>"

$data |Sort-Object -Property Count, Name -Descending |
    Select-Object Count, Name | 
    ConvertTo-Html -Title $ReportTitle -PreContent $precontent  -PostContent $footer -CssUri $css |
    Out-File $Path


