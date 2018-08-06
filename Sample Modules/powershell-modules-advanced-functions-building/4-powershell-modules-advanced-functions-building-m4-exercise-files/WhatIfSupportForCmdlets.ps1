## Use WhatIf as a test run
$WhatIfPreference
Get-ChildItem -Path 'C:\' -Recurse | Remove-Item -Recurse -WhatIf

## Use -Confirm on all potentially dangerous actions
$ConfirmPreference
Get-ChildItem -Path 'C:\' -Recurse | Remove-Item -Recurse -Confirm

mkdir C:\test123 -Confirm