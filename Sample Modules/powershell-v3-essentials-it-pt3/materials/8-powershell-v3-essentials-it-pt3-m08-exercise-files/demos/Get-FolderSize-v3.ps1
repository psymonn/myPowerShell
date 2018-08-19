#requires -version 3.0

Function Get-FolderSize {
[cmdletbinding()]

Param(
[Parameter(Position=0)]
[ValidateScript({Test-Path $_})]
[string]$Path="."
)

Write-Verbose "Analyzing $path"

Get-ChildItem -path $Path -Directory | foreach -begin {
 #measure files in $Path
 $stats = Get-ChildItem -Path $path -file | 
 Measure-Object -Property length -sum

 if ($stats.count -eq 0) {
   $size = 0
 }
 else {
    $size=$stats.sum
 }
 $root = Get-Item -Path $path
 
 $hash = [ordered]@{
 Fullname = $root.FullName
 Name = $root.Name
 Size = $size
 Count = $stats.count
 }

 New-Object -TypeName PSobject -Property $hash
} -process { 
 $stats = dir $_.fullname -file -recurse | 
 Measure-Object -Property length -sum
 if ($stats.count -eq 0) {
   $size = 0
 }
 else {
    $size=$stats.sum
 }

 $hash = [ordered]@{
 Fullname = $_.FullName
 Name = $_.Name
 Size = $size
 Count = $stats.count
 }

 New-Object -TypeName PSobject -Property $hash
 } 

} #end Get-FolderSize