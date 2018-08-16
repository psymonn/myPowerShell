[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$UserName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$FirstName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$LastName
)

$homeDir = "\\REDINK-DC-01\HomeFolders\$UserName"
$companyDefaultOUPath = 'OU=CompanyUsers,DC=REDINK,DC=COM'

## Create AD user
if (-not (Get-AdUser -Filter "samAccountName -eq '$UserName'")) {
    New-AdUser -Name $UserName -GivenName $FirstName -Surname $LastName -HomeDirectory $homeDir -Path $companyDefaultOUPath
}

## Create home folder for new user
if (-not (Test-Path -Path $homeDir)) {
    New-Item -Path $homeDir
}