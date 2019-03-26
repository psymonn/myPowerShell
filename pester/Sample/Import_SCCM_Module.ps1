###################################################################################################################
#### 115 character width indicator ####
###################################################################################################################

<#
.Synopsis
    Loads the Configuration Manager module.
.DESCRIPTION
    Loads the Configuration Manager module, which is required to be able to run SCCM commands. The script set the
    location of the console to the PSDrive CAS:\, which is where SCCM commands must be run from.

#>

#Run this line of code to load the SCCM PowerShell module (Configuration Manager module)

Import-Module 'C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1'

#If a PSDrive CAS is not created then uncomment and run the following line of code.
#### New-PSDrive -Name CAS -PSProvider CMSite -Root 'EUCDEVSCCM01'

#To run Configuration Manager cmdlets the location needs to be set to the SCCM PSDrive
Set-Location 'CAS:'
