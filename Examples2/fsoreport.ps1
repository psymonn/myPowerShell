#get disk usage using the FilesystemObject
[cmdletbinding()]
Param(
[Parameter(Position = 0)]
[ValidatePattern("^[A-Za-z]:$")]
[ValidateNotNullOrEmpty()]
[string]$Drive='C:',
[Parameter(Position = 1)]
[ValidateSet("none","KB","MB","GB")]
[string]$Units = "gb"
)

$fso = new-object -com scripting.filesystemobject

Try {
    $data = $fso.GetDrive($Drive)
}
catch {
    Write-Warning "Could not find drive $Drive on $($env:computername)"
    #bail out
    Return
}
Switch ($Units) {
    "none" {$unit = 1 ; $label=""}
    "kb" { $unit = 1KB ; $label="KB"}
    "mb" { $unit = 1MB ; $label="MB"}
    "gb" { $unit = 1GB ; $label="GB"}

}

$data | Select-object Path,VolumeName,
@{Name="Size$label";Expression={($_.TotalSize/$unit) -as [int]}},
@{Name="Free$Label";Expression={[math]::round($_.FreeSpace/$unit,2)}},
@{Name="Available$Label";Expression={[math]::Round($_.AvailableSpace/$unit,2)}},
@{Name="RootFiles";Expression = { $_.RootFolder.files | Select-object Name,Size,Date* }},
@{Name="ReportDate";Expression = {(Get-Date -format "yyyy/MM/dd")}},
@{Name="Computername";Expression = {$env:computername}}