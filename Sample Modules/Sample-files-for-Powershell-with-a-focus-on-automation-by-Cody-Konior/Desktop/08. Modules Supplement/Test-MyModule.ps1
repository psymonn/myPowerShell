<#

.SYNOPSIS
This test something.

.DESCRIPTION
It's a really good test.

.PARAMETER PrintString
A string to test for printing.

.EXAMPLE
Test-MyModule

.NOTES
Modification History

Date        By			Description
2014-07-21  C Konior    Added help.

#>
function Test-MyModule (
    $PrintString = "Yes, it loaded ok!"
    ) {

	Write-Host $PrintString
}

