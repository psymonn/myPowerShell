<#
#didn't work!!
# Set variables
$global:var1
$global:var2
$global:var3

function foo ($a, $b, $c)
{
    # Add $a and $b and set the requested global variable to equal to it
    $c = $a + $b
}

foo 1 2 $global:var3

#>


$global:myLogText = ""
function AddLog ($Message)
{
    $global:myLogText += ($Message)
}
AddLog ("Hello")
Write-Host $global:myLogText