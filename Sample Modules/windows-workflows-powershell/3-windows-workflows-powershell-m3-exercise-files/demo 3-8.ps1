#    Demo 3-8
#    Workflow Preference Variables

Workflow Invoke-Preference 
{ 
  Param ($pref)
  # set preference variable
  $PSPersistPreference = $pref
# rest of workflow
  $a = 42
  $i = Get-CimInstance win32_bios 
  $b = 42
}

$s = Get-date ; Invoke-Preference -pref $true
$e = Get-date ; " Total time: {0}" -f ($e-$s).TotalMilliseconds
$s = Get-date ; Invoke-Preference -pref $false
$e = Get-date ; " Total time: {0}" -f ($e-$s).TotalMilliseconds