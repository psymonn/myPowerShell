$requiredFiles = (Get-Module MyTools -ListAvailable).FileList
$requiredFiles | foreach {
    if (-not (Test-Path -Path $_ -PathType Leaf)) {
        Write-Warning "The file [$($_)] does not exist and is required for this module."       
    } 
}