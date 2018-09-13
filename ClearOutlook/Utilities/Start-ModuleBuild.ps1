<#
.Synopsis
   Initiates the build of the module once the template has been populated.
.DESCRIPTION
   This Cmdlet creates the module manifest file and specifies the contents of the Public folder in the "FunctionsToExport" attribute.
.EXAMPLE
   Start-ModuleBuild -ModuleDirectoryPath C:\Temp\TestModule -ModuleName TestModule
#>
Function Start-ModuleBuild
{
    [Cmdletbinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({
            If(-not (Test-path $_)) {
                Throw "Directory does not exist"
            }
            Else {
                Return $true
            }
        })]
        [String]$ModuleDirectoryPath,
        [Parameter(Mandatory = $true)]
        [String]$ModuleName
    )
    $PublicFunctions = @((Get-ChildItem -Path "$($ModuleDirectoryPath)\Public\*.ps1").BaseName)
    $ModuleManifest = (Get-ChildItem "$($ModuleDirectoryPath)\*.psd1")
    If($ModuleManifest) {
        Update-ModuleManifest -Path $ModuleManifest -FunctionsToExport $PublicFunctions
    }
    Else {
        New-ModuleManifest -Path "$($ModuleDirectoryPath)\$($ModuleName).psd1" -RootModule ".\$($ModuleName).psm1" -FunctionsToExport $PublicFunctions -ErrorAction Stop
    }
}

#verified
Start-ModuleBuild -ModuleDirectoryPath C:\Data\Scripts\TestModule\myNewModule -ModuleName myNewModule
