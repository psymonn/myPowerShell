#
#
#  M4.psm1
#  A simple part of a manifest module

function Get-Greeting {
"Hello World - from manifest module M4"
}

function DoNotExportMe { 'In do not export'}
function ExportMe      { "calling DoNotExportMe"; DoNotExportMe}

Export-ModuleMember -Function ExportMe, Get-Greeting
