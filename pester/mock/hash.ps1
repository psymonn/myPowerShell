Clear-Host
$ErrorActionPreference = "Stop"

$hash=[ordered]@{a=2;b=3;c=4;d=5}
$list = New-Object System.Collections.ArrayList

foreach ($h in $hash.Keys) {
    Write-Host "${h}: $($hash.Item($h))"

    if ($($hash.Item($h)) -eq 4) {
        $null = $list.Add($h)
    }
}

foreach ($h in $list)
{
    $hash.Remove($h)
}

Write-Host ''

foreach ($h in $hash.Keys) {
    Write-Host "${h}: $($hash.Item($h))"
}
