#region Demo Setup
$demoFolder = 'C:\Dropbox\Business Projects\Courses\Pluralsight\Course Authoring\Active Courses\building-advanced-powershell-functions-and-modules\building-advanced-powershell-functions-and-modules-m7\Demos'
#endregion

#region Setup and pre-configuration

Import-Module -Name MyModule -Force
$module = Get-Module -Name MyModule
$module
ise (Join-Path -Path $module.ModuleBase -ChildPath 'MyModule.psm1')
ise $module.Path

## No help for the functions
Get-Help Get-VirtualMachine

#endregion

#region Create the folder on the IIS server
mkdir \\labdc.lab.local\c$\inetpub\wwwroot\PSHelp
#endregion


#region Modifying the existing manifest

## Add the HelpInfoUri key
<#
    HelpInfoURI = 'http://labdc.lab.local/PSHelp'
#>
ise $module.Path

## Reload the module
$module = Import-Module MyModule -Force -PassThru
$module.HelpInfoUri

#endregion

#region Prepare the local files

#region Ensure the local XML help file is the right name

$localXmlHelp = "$demoFolder\XML Help\Module Help\MyModule.psm1-help.xml"
Get-Item $localXmlHelp

#endregion

#region Create the Helpinfo file anywhere on the local computer
$helpInfoFile = New-Item -Path "C:\Users\administrator.lab\Documents\MyModule_$($module.Guid)_HelpInfo.xml" -Type File
$helpInfoFile

## HelpContentURI is the same URI in the manifest
$module.HelpInfoUri

<#
<?xml version="1.0" encoding="utf-8"?>
<HelpInfo xmlns="http://schemas.microsoft.com/powershell/help/2010/05">
  <HelpContentURI>http://labdc.lab.local/PSHelp/</HelpContentURI>
  <SupportedUICultures>
     <UICulture>
       <UICultureName>en-US</UICultureName>
       <UICultureVersion>3.2.15.0</UICultureVersion>
     </UICulture>    
  </SupportedUICultures>
</HelpInfo>
#>

ise $helpInfoFile.FullName
#endregion

#region Create the CAB file

## CAB file needs to be in the form ModuleName_ModuleGUID_UICulture_HelpContent.cab

$module.Guid
$module.Name

$cabFileName = "$($module.Name)_$($module.Guid)_en-US_HelpContent.cab"
$cabFileName

## Put the XML help file and HelpInfo XML file into the CAB file
## No good command line way --use Ian Brighton's script

# http://virtualengine.co.uk/2014/creating-cab-files-with-powershell/

. "$demoFolder\New-CabinetFile.ps1"

## Create a CAB file anywhere locally
$cabFile = Get-Item $localXmlHelp | New-CabinetFile -Name $cabFileName -DestinationPath 'C:\Users\administrator.lab\Documents'
iex $cabFile.FullName

## Copy the CAB file to the remote server
copy $cabFile.FullName '\\labdc.lab.local\c$\inetpub\wwwroot\PSHelp'

## Copy the HelpInfo XML to the remote server
copy $helpInfoFile.FullName '\\labdc.lab.local\c$\inetpub\wwwroot\PSHelp'

## Modify IIS permissions

## Verify I can see the files from the webpage
start http://labdc.lab.local/PSHelp/

#endregion

#region Testing updatable help

## Confirm no help shows up
Get-help Get-VirtualMachine

## Load the HelpInfo.xml
Update-Help -Module MyModule -SourcePath \\labdc.lab.local\c$\Inetpub\wwwroot\PSHelp\ -Force

## Use Update-Help as normal
Update-Help -Module MyModule -Force

## We have help!
Get-help Get-VirtualMachine

#endregion