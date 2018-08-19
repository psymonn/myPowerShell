param([string]$ComputerName = 'localhost',[datetime]$StartTimestamp,[datetime]$EndTimestamp)

$Logs = (Get-WinEvent -ListLog * -ComputerName $ComputerName | where { $_.RecordCount }).LogName
$FilterTable = @{
	'StartTime' = $StartTimestamp
	'EndTime' = $EndTimestamp
	'LogName' = $Logs
}
		
Get-WinEvent -ComputerName $ComputerName -FilterHashtable $FilterTable -ErrorAction 'SilentlyContinue'

#.\Get-WinEventWithin.ps1 -StartTimestamp '08-18-18 04:00' -EndTimestamp '08-18-18 11:00'
#(.\Get-WinEventWithin.ps1 -StartTimestamp '08-18-18 04:00' -EndTimestamp '08-18-18 11:00').count