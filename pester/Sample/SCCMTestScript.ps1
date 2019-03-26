<#
.Synopsis
    Script to run pester testing.
.DESCRIPTION
    This script runs the peseter tests for the following functions:
        Get-ExistingSCCMBoundaryErrorMessage
        Convert-CIDRToSubnetId
        Check-SCCMBoundaryDelete
        Check-SCCMBoundaryModify
        Check-SCCMBoundaryCreate
        Create-SCCMBoundary
        Modify-SCCMBoundary
        Delete-SCCMBoundary

    The code has several sections. By highlighting a given section as running as a selection (F8), the a pester
    test for a specific function can be run.

.NOTES
    Pester version 4.4.2 is required to be loaded into the PowerShell session.
#>



<<<<<<< HEAD
$fileRoot = "\\eucdevstore01\SCCMSTORE\Users\michael.antolin_priv\SCCM_Scripting_Project"
=======
#$fileRoot contains the path of the local repo - update to reflect the location of your own local repo
$fileRoot = "\\eucdevstore01\SCCMSTORE\Users\jamie.bialecki_priv\SCCM Boundary Code\SCCM_Scripting_Project"
>>>>>>> fb3a8b4993cc3f9f9b07f9fa27896ffab87205ec

###################################################################################################################
#### PESTER TESTING FOR GET-EXISTINGSCCMBOUNDARYERRORMESSAGE ####
###################################################################################################################

Clear-Host

Set-Location C:

Invoke-Pester -Script "$fileRoot\Get-ExistingSCCMBoundaryErrorMessage.Test.ps1"

###################################################################################################################
#### PESTER TESTING FOR Convert-CIDRToSubnetId ####
###################################################################################################################

Clear-Host

Set-Location C:

Invoke-Pester -Script "$fileRoot\Convert-CIDRToSubnetId.Test.ps1"

###################################################################################################################
#### PESTER TESTING FOR Check-SCCMBoundaryDelete ####
###################################################################################################################

Clear-Host

Set-Location C:

Invoke-Pester -Script "$fileRoot\Check-SCCMBoundaryDelete.Test.ps1"

###################################################################################################################
#### PESTER TESTING FOR Check-SCCMBoundaryCreate ####
###################################################################################################################

Clear-Host

Set-Location C:

Invoke-Pester -Script "$fileRoot\Check-SCCMBoundaryCreate.Test.ps1"

###################################################################################################################
#### PESTER TESTING FOR Check-SCCMBoundaryModify ####
###################################################################################################################

Clear-Host

Set-Location C:

Invoke-Pester -Script "$fileRoot\Check-SCCMBoundaryModify.Test.ps1"

###################################################################################################################
#### PESTER TESTING FOR CREATE-SCCMBOUNDARY ####
###################################################################################################################

Clear-Host

Set-Location C:

Invoke-Pester -Script "$fileRoot\Create-SCCMBoundary.Test.ps1"

###################################################################################################################
#### PESTER TESTING FOR DELETE-SCCMBOUNDARY ####
###################################################################################################################

Clear-Host

Set-Location C:

Invoke-Pester -Script "$fileRoot\Delete-SCCMBoundary.Test.ps1"

###################################################################################################################
#### PESTER TESTING FOR MODIFY-SCCMBOUNDARY ####
###################################################################################################################

Clear-Host

Set-Location C:

Invoke-Pester -Script "$fileRoot\Modify-SCCMBoundary.Test.ps1"
