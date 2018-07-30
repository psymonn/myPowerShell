#requires -version 4.0

#this script has intentional errors

#get trusted hosts entry
$th = get-item WSMan:\localhost\Client\TrustedHosts

$noTrusted = $True
if ($th.Value) {
  $noTrusted = $False
}

#get PowerShell version
$psver = $PSVersionTable.PSVersion

#get OS
$OS = Get-CimInstance Win32_Operatingsystem

$hash=[ordered]@{
    Computername = $os.CSName
    OS = $os.Verson
    TrustedHosts = $th.value
    Source = $th.SourceOfValue
    HasTrustedHosts = $noTrusted
}

[pscustomobject]$Hash