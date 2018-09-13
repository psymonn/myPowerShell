<#
.Synopsis
   Deploys a standardised module template to a specified location
.DESCRIPTION
   This Cmdlet creates the framework of a PowerShell module that can then be populated with functions. The objects created are:
     - The overall module directory (The name is taken from the "ModuleName" parameter)
     - Subdirectories for Public and Private functions
     - The .psm1 file for the Module (this is copied from the template stored in the ModuleBuild module)
.EXAMPLE
   New-ModuleTemplate -ModulePath C:\Temp -ModuleName TestModule
#>
Function New-ModuleTemplate {
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
        [String]$ModulePath,

        [Parameter(Mandatory = $true)]
        [string]$ModuleName
    )

    Process {
        $FullModulePath = $ModulePath + "\" + $ModuleName
        If(Test-Path -Path "$($FullModulePath)") {
            Write-Error "$($ModuleName) already exists at $($ModulePath)" -ErrorAction Stop
        }
        Else {
            try {
                #Create Module Directory
                New-Item -Path $ModulePath -Name $ModuleName -ItemType Directory -ErrorAction Stop | Out-Null
            }
            catch {
                Write-Error "Failed to Create Module Directory" -ErrorAction Stop
            }
            try {
                #Create the Module's Internal Directory Structure
                New-Item -Path $FullModulePath -Name "Public" -ItemType Directory -ErrorAction Stop | Out-Null
                New-Item -Path $FullModulePath -Name "Private" -ItemType Directory -ErrorAction Stop | Out-Null
            }
            catch {
                Write-Error -Message "Failed to create Directory Structure in $($FullModulePath)"
            }
            try {
                #Copy .psm1 template and rename it
                #$Psm1File = Get-Item "$($PSScriptRoot)\..\*.psm1"
                $Psm1File = Get-Item "$($ModulePath)\template\*.psm1"
                write-host "PSMFILE: $Psm1File"
                Copy-Item $Psm1File -Destination "$($FullModulePath)\$($Modulename).psm1" -ErrorAction Stop
            }
            catch {
                Write-Error -Message "Failed to copy .psm1 template to $($FullModulePath)" -ErrorAction Stop
            }
        }
    }
}


#verified
New-ModuleTemplate -ModulePath C:\Data\Scripts\TestModule -ModuleName myNewModule



