## Demo 1
Get-CimInstance -ClassName Win32_OperatingSystem -Namespace 'root\cimv2' -Property SerialNumber -OperationTimeoutSec 10 -QueryDialect WQL -KeyOnly -Verbose

Get-Help Get-CimInstance -ShowWindow

## Demo 2
$Parameters = @{
	'Filter' = *
	'Path' = 'C:\'
}

Get-ChildItem @Parameters