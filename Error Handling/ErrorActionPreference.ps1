function Test-ErrorActionPreference ([String] $Preference) {

    Write-Host ''
    Write-Host "Preference: $Preference"

    $ErrorActionPreference = $Preference
    write-host 'Statement before the error.'

    Get-item c:\does\not\exsit.txt

    Write-Host 'Statement after the error.'
}

Test-ErrorActionPreference 'Continue'
Test-ErrorActionPreference 'SilentlyContinue'
Test-ErrorActionPreference 'Stop'