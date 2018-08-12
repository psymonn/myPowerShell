#region Demo stuff
$demoPath = 'C:\Dropbox\Business Projects\Courses\Pluralsight\Course Authoring\Active Courses\pester-infrastructure-testing\pester-infrastructure-testing-m4\Demos\3. Creating Dependencies from Scratch'

## Ensure the CompanyUsers OU does not exist
$ou = Get-ADOrganizationalUnit -Identity 'OU=CompanyUsers,DC=mylab,DC=local'
$ou | Set-ADObject -ProtectedFromAccidentalDeletion:$false
Get-Aduser -Filter "samAccountName -eq 'mjones'" | Remove-AdUser -Confirm:$False
$ou | Remove-ADOrganizationalUnit -Confirm:$false

## Ensure the the MEMBERSRV1 home folders share does not exist
icm -ComputerName MEMBERSRV1 -ScriptBlock {Get-SmbShare -Name HomeFolders | Remove-SmbShare -Confirm:$false}
Remove-Item -Path \\MEMBERSRV1\c$\HomeFolders -Force -Recurse

#endregion

Invoke-Pester "$demoPath\New-BusinessUser.Tests.ps1"

## Run again to show all requirements and dependencies are met