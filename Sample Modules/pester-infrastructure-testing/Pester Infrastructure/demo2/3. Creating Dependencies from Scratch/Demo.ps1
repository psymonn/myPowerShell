#region Demo stuff
$demoPath = 'Z:\POWERSHELL\pester-infrastructure-testing\4-pester-infrastructure-testing-m4-exercise-files\Demos\3. Creating Dependencies from Scratch'
#$demoPath = 'F:\STUDYING\a PLURALSIGHT Courses\POWERSHELL\pester-infrastructure-testing\4-pester-infrastructure-testing-m4-exercise-files\Demos\3. Creating Dependencies from Scratch'

## Ensure the CompanyUsers OU does not exist
$ou = Get-ADOrganizationalUnit -Identity 'OU=CompanyUsers,DC=redink,DC=com'
$ou | Set-ADObject -ProtectedFromAccidentalDeletion:$false
Get-Aduser -Filter "samAccountName -eq 'mjones'" | Remove-AdUser -Confirm:$False
$ou | Remove-ADOrganizationalUnit -Confirm:$false

## Ensure the the MEMBERSRV1 home folders share does not exist
icm -ComputerName REDINK-DC-01 -ScriptBlock {Get-SmbShare -Name HomeFolders | Remove-SmbShare -Confirm:$false}
Remove-Item -Path \\REDINK-DC-0\c$\SHARES\HomeFolders -Force -Recurse

#endregion

Invoke-Pester "$demoPath\New-BusinessUser.Tests.ps1"

## Run again to show all requirements and dependencies are met