<#
    run this in powershell V2
#>
$PSVersionTable

$name = "Peter" 
$value = "Singer/Songwriter" 
"$name is a $value" 
"$name: $value"

cls

#@'
function set-name( $newname )
{
    $name = $newname
}
#@'

$name
set-name 'Paul'
$name

#@'
function set-name( $newname )
{
    $global:name = $newname
}

set-name 'Paul'
$name


get-help about_scopes

cls

<# 
    So what exactly is happening in our interpolated string example?
#>
#this works as expected...
"$name is a $value" 
# but this doesn't.  why?
"$name: $value"

<#
    The $name: looks to PowerShell like a scoped variable reference.  In this case, the scope is name and the variable
    has no name.

    In V2, PowerShell would silently fail when it encountered this.  It would not produce an error, but it also would
    not produce the expected output.

    In V3, a "breaking fix" has been added that raises an error when this "nameless variable" is encountered.
#> 

<#
    run this in powershell V3
#>
$PSVersionTable

ls | foreach-object { "File $_: "+ $_.length +" bytes" }

# note that using the $variablename: pattern results in an error

<#
    so what can we do about it?

    the safest thing to do is to get in the habit of delimiting your variable names 
    with {} inside of interpolated string:
#>

"${name}: $value"

# you can also include a scope modifier in the {} as well
"${global:name}: $value"


ls | foreach-object { "File ${_}: "+ $_.length +" bytes" }

<#
    with the extra help, powershell is able to determine that we mean to reference
    the local $_ variable, and not a no-name variable in the _ scope (or a variable 
    named _: in the local scope for that matter)
#>