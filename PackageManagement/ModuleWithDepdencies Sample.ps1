PS C:\windows\system32> Get-InstalledModule

PS C:\windows\system32> Find-Module -Repository GalleryINT -Name ModuleWithDependencies2 -IncludeDependencies
Version Name                    Type   Repository Description
------- ----                    ----   ---------- -----------
2.0     ModuleWithDependencies2 Module GalleryINT ModuleWithDependencies2
2.5     RequiredModule1         Module GalleryINT RequiredModule1
2.5     RequiredModule2         Module GalleryINT RequiredModule2
2.5     RequiredModule3         Module GalleryINT RequiredModule3
2.0     RequiredModule4         Module GalleryINT RequiredModule4
1.5     RequiredModule5         Module GalleryINT RequiredModule5
2.5     NestedRequiredModule1   Module GalleryINT NestedRequiredModule1
2.5     NestedRequiredModule2   Module GalleryINT NestedRequiredModule2
2.5     NestedRequiredModule3   Module GalleryINT NestedRequiredModule3
2.0     NestedRequiredModule4   Module GalleryINT NestedRequiredModule4
1.5     NestedRequiredModule5   Module GalleryINT NestedRequiredModule5

PS C:\windows\system32> Install-Module -Repository GalleryINT -Name ModuleWithDependencies2 -Scope CurrentUser

PS C:\windows\system32> Get-InstalledModule
Version Name                    Type    Repository Description
------- ----                    ----    ---------- -----------
2.0     ModuleWithDependencies2 Module GalleryINT ModuleWithDependencies2
2.5     NestedRequiredModule1   Module GalleryINT NestedRequiredModule1
2.5     NestedRequiredModule2   Module GalleryINT NestedRequiredModule2
2.5     NestedRequiredModule3   Module GalleryINT NestedRequiredModule3
2.0     NestedRequiredModule4   Module GalleryINT NestedRequiredModule4
1.5     NestedRequiredModule5   Module GalleryINT NestedRequiredModule5
2.5     RequiredModule1         Module GalleryINT RequiredModule1
2.5     RequiredModule2         Module GalleryINT RequiredModule2
2.5     RequiredModule3         Module GalleryINT RequiredModule3
2.0     RequiredModule4         Module GalleryINT RequiredModule4
1.5     RequiredModule5         Module GalleryINT RequiredModule5

PS C:\windows\system32> $module = Get-Module -Name ModuleWithDependencies2 -ListAvailable

PS C:\windows\system32> $module

Directory: C:\Users\manikb\Documents\WindowsPowerShell\Modules
ModuleType Version Name                    ExportedCommands
---------- ------- ----                    ----------------
Manifest   2.0     ModuleWithDependencies2 {Get-NestedRequiredModule1, Get-NestedRequiredModule2, Get-NestedRequiredModule3, Get-NestedRequiredModule4...}

------------------------------------------------------------
Contents of ModuleWithDependencies2 module manifest file (psd1 file):
------------------------------------------------------------

@{
# Version number of this module.
ModuleVersion = '2.0'

# ID used to uniquely identify this
GUID = '0eae34da-99dd-4608-8d28-c614fe7b0841'

# Author of this
Author = 'manikb'

# Company or vendor of this
CompanyName = 'Unknown'

# Copyright statement for this
Copyright = '(c) 2015 manikb. All rights reserved.'

# Description of the functionality provided by this
Description = 'ModuleWithDependencies2 module'

# Modules that must be imported into the global environment prior to importing this
RequiredModules = @('RequiredModule1',
@{ModuleName = 'RequiredModule2'; ModuleVersion = '2.0'; },
@{ModuleName = 'RequiredModule3'; RequiredVersion = '2.5'; },
@{ModuleName = 'RequiredModule4'; ModuleVersion = '1.1'; MaximumVersion = '2.0'; },
@{ModuleName = 'RequiredModule5'; MaximumVersion = '1.5'; })

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @('NestedRequiredModule1',
@{ModuleName = 'NestedRequiredModule2'; ModuleVersion = '2.0'; },
@{ModuleName = 'NestedRequiredModule3'; RequiredVersion = '2.5'; },
@{ModuleName = 'NestedRequiredModule4'; ModuleVersion = '0.7'; MaximumVersion = '2.4'; },
@{ModuleName = 'NestedRequiredModule5'; MaximumVersion = '1.6'; },'ModuleWithDependencies2.psm1')

# Functions to export from this
FunctionsToExport = '*'

# Cmdlets to export from this
CmdletsToExport = '*'

# Variables to export from this
VariablesToExport = '*'

# Aliases to export from this
AliasesToExport = '*'

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{
    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'Tag1', 'Tag2', 'Tag-ModuleWithDependencies2-2.0'

        # A URL to the license for this module.
        LicenseUri = 'http://modulewithdependencies2.com/license'

        # A URL to the main website for this project.
        ProjectUri = 'http://modulewithdependencies2.com/'

        # A URL to an icon representing this module.
        IconUri = 'http://modulewithdependencies2.com/icon'

        # ReleaseNotes of this
        ReleaseNotes = 'ModuleWithDependencies2 release notes'
    } # End of PSData hashtable
} # End of PrivateData hashtable
}
