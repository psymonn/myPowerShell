#region Demo stuff
$demoPath = 'C:\Dropbox\Business Projects\Courses\Pluralsight\Course Authoring\Active Courses\pester-infrastructure-testing\pester-infrastructure-testing-m4\Demos\1. Identifying Infrastructure Dependencies'

## Ensure the CompanyUsers OU does not exist
$ou = Get-ADOrganizationalUnit -Identity 'OU=CompanyUsers,DC=mylab,DC=local'
$ou | Set-ADObject -ProtectedFromAccidentalDeletion:$false
Get-Aduser -Filter "samAccountName -eq 'mjones'" | Remove-AdUser -Confirm:$False
$ou | Remove-ADOrganizationalUnit -Confirm:$false

## Ensure the the MEMBERSRV1 home folders share does not exist
icm -ComputerName MEMBERSRV1 -ScriptBlock {Get-SmbShare -Name HomeFolders | Remove-SmbShare -Confirm:$false}
Remove-Item -Path \\MEMBERSRV1\c$\HomeFolders -Force -Recurse


#endregion

## Call the script to create the AD user and home folder. We're assuming that this is going to do what we want but
## what other stuff must be in place before that can happen anyway? Let's try and find out!
& "$demoPath\New-BusinessUser.ps1" -UserName mjones -FirstName Mary -LastName Jones

## Confirm the OU exists
Get-ADOrganizationalUnit -Identity 'OU=CompanyUsers,DC=mylab,DC=local'

## Confirm the home folder share is setup
icm -ComputerName MEMBERSRV1 -ScriptBlock {Get-SmbShare -Name HomeFolders }

#region Demo stuff

## create the home folder share
mkdir \\membersrv1\c$\HomeFolders
icm -ComputerName MEMBERSRV1 -ScriptBlock {New-SmbShare -Name HomeFolders -Path C:\HomeFolders -FullAccess Everyone}

## Create the AD OU
New-ADOrganizationalUnit -Path 'DC=mylab,DC=local' -Name CompanyUsers -Server DC

<#
 ########## Prerequisites ###################

 1. The MEMBERSRV1 file server must have a HomeFolders share available.
 3. The CompanyUsers AD OU must exist.
 4. ...and other we didn't discuss.
   - servers online?
   - file systems online?
   - at some point, you have to make assumptions

#>

#endregion
