#one off template creation
Install-Module Plaster

$manifestProperties = @{
    Path = ".\FullModuleTemplate\PlasterManifest.xml"
    Title = "Full Module Template"
    TemplateName = 'FullModuleTemplate'
    TemplateVersion = '0.0.1'
    Author = 'Psymon Ng'
    Description = "Some description"
    TemplateType = "Item"
}

New-Item -Path FullModuleTemplate -ItemType Directory
New-PlasterManifest @manifestProperties
#New-PlasterManifest -TemplateName NewPowerShellItem -TemplateType Item 
#New-PlasterManifest -TemplateName NewPowerShellItem -TemplateType Item -AddContent
#New-PlasterManifest -TemplateName NewPowerShellItem -TemplateType Item -TemplateVersion 0.1.0 -Description "Some 
#    description." -Tags Module, Publish,Build

######################
# Once its created, use the template to update the contents and parameters

$plaster = @{
    TemplatePath = (Split-Path $manifestProperties.Path)
    DestinationPath = "F:\scripts\Plaster\Temp\Module"
}

New-Item -ItemType Directory -Path $plaster.DestinationPath
Invoke-Plaster @plaster -Verbose
#----------------------------------------------------------

Remove-Item -Path $plaster.DestinationPath -Recurse
New-Item -ItemType Directory -Path $plaster.DestinationPath

Invoke-Plaster @plaster -Verbose