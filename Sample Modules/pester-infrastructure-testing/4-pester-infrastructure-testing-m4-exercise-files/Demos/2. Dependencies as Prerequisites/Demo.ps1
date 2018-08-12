#region Demo stuff
$demoPath = 'C:\Dropbox\Business Projects\Courses\Pluralsight\Course Authoring\Active Courses\pester-infrastructure-testing\pester-infrastructure-testing-m4\Demos\2. Dependencies as Prerequisites'

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

#region Create the dependencies
## create the home folder share
mkdir \\membersrv1\c$\HomeFolders
icm -ComputerName MEMBERSRV1 -ScriptBlock {New-SmbShare -Name HomeFolders -Path C:\HomeFolders -FullAccess Everyone}

## Create the AD OU
New-ADOrganizationalUnit -Path 'DC=mylab,DC=local' -Name CompanyUsers -Server DC
#endregion

## Run the tests again
Invoke-Pester "$demoPath\New-BusinessUser.Tests.ps1"


#endregion
