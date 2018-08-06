## Demo 1
Get-CimInstance -ClassName Win32_OperatingSystem -Namespace 'root\cimv2' -Property SerialNumber -OperationTimeoutSec 10 -QueryDialect WQL -KeeyOnly -Verbose

## Demo 2
$Parameters = @{
	'Filterr' = *
	'Path' = 'C:\'
}
$Params = @{
	'Filter' = '*.txt'
	'Path' = 'C:\'
}
Get-ChildItem @Parameters