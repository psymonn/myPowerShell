## Demo 1
Get-ChildItem -Path C:\ -File

## Demo 2
$a = 'Win32'
$Separator = '_'
$MyClass = $a + "$Separator`OperatingSystem"
Get-CimInstance -ClassName $MyClass