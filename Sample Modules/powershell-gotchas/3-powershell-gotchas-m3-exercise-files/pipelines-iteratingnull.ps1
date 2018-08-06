# note: run this demo in PowerShell v3

$psversiontable

<#
    there are two basic ways to iterate on things in PowerShell
#>

$f = dir;
foreach( $file in $f ) { "This item is $file" }
cls
$f | foreach-object { "This item is still $_" }

cls

<#
    $a has no value 
#>
$a

<#
    what do you think will happen when I hit enter?
#>
foreach( $item in $a ) { "iteration" }

<# 
    Nothing is output. 
    Makes sense - $a has no value, so how can you iterate it?

    now, allow me to blow your mind...
#>
$a | foreach-object { "iteration" }

<#
    What?  $a has no value but foreach-object will iterate it once?

    What exactly is going on here?
#>

cls

<#
    
    check it out - this may help clarify the difference:
#>
function get-nothing {}
function get-null { $null }


<#
    the first function returns nothing - literally no value at all;
    the second function returns a null reference
#>

get-nothing | foreach-object { "nothing" }
get-null | foreach-object { "null value" }


<#
    the best part, in PowerShell v2, both statements behaved identically
    but in PowerShell v3, the behavior of the foreach statement (not the cmdlet)
    changed!    
#>

#... run this part of the demo in powershell -version 2
$psversiontable
$a
foreach( $item in $a ) { "iteration" }
$a | foreach-object { "iteration" }

# ... back in powershell -version 3
<#
    one strategy you can employ is to use PowerShell in strict mode.
    Strict mode puts best-practice restrictions on your code and
    will prevent you from using undefined variables:
#>
set-strictmode -version 3
$a

# note the error in attempting to access an undefined variable
$a | foreach-object { "iteration" }