#Get Function reference files
$PrivateFunctions = @(Get-ChildItem $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)
$PublicFunctions = @(Get-ChildItem $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)

#Dot source files - Functions are exported through the Module Manifest
Foreach ($Import in @($PrivateFunctions + $PublicFunctions))
{
    try {
        . $Import.FullName -ErrorAction stop
    }
    catch {
        "Error importing $($Import.FullName)."
    }
}
#Import Parameters if present as $Global:*ModuleName*Params
$ModuleName = "$((Get-Item .\).Name)Params"
If(Test-Path .\Parameters.Json)
{
    $JsonImport = Get-Content .\Parameters.json -Raw -Force
    $ConvertedParameters = ConvertFrom-Json $JsonImport
    If(Get-Variable -Name "$($ModuleName)" -Scope Global -ErrorAction SilentlyContinue)
    {
        Set-Variable -Name "$($ModuleName)" -Scope Global -Value $ConvertedParameters
    }
    Else
    {
        New-Variable -Name $ModuleName -Scope Global -Value $ConvertedParameters
    }
}
