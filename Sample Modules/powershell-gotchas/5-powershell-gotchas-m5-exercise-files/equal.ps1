<#
    let's begin by defining two values a and b:
#>
#>$a = 0 # $global:a=0
#>$b = '' # $global:b=''

# do you think powershell will consider these two values equal?
# let's find out:
$a -eq $b

<#
    here we see that even though a is zero and b is 
    an empty string, PowerShell considers them 'equal'.

    makes sense, since they both kind of mean the same 
    thing, they both represent "no value" for their
    respective types
#>

# but what happens if we reverse the order of the operands?

$b -eq $a
<#
    suddenly PowerShell doesn't think they're equal anymore...

    but how could that be possible?  I mean, according to
    PowerShell, this logical statement - which should NEVER
    be true - is true for this very simple case:
#>
($a -eq $b) -ne ($b -eq $a)

<#
    As it often does, PowerShell is trying to help us out here.

    PowerShell is a typed language, as much as it tries to hide
    that fact from us.

    Our variables A and B have specific .NET types:
#>
cls
$a.gettype()
$b.gettype()

<#
    Since they're different types, PowerShell needs to convert one or
    the other to perform the value comparison.  

    PowerShell includes a deep and extensive type conversion system
    that DOES NOT have an equivalent in .NET
#>

# for instance, in powershell I can cast an empty string to an int:
[int]$b
# but .NET won't allow that:
[convert]::ToInt32($b);

cls

<#
    let's explicitly spell out the first case, where A -eq B is true.
#>
[int]''

<#
    again, this makes sense: transforming "" into an int feels like 
    it should be 0.

    now look at this case:
#>
[string]0

<#
    spelling out the conversions that are taking place, this statement
    makes perfect sense: transforming the number 0 into a string should
    result in the string "0", not an empty string.

    suddenly the universe make sense again...
#>

cls

<#
    this gotcha takes other forms as well.

    Check this out: a $null reference equals a $null reference:
#>
$null -eq $null

# unless one of those $null references is a string:
$null -eq [string]$null

<#
    ever passed a null string reference to a .NET method from
    PowerShell?

    No, you haven't; you've passed an empty string instead.

    Check this out: here we're adding a public type with a single
    static method that accepts a string.

    The method returns "NULL" if the string is a null reference,
    "EMPTY" if the string is an empty string, and the value of the string
    in other cases:
#>
#@'
add-type @'
using System;
public class Equality
{
    public static string TestNullString(string str)
    {
        if (null == str)
        {
            return "NULL";
        }
        else if (String.Empty == str)
        {
            return "EMPTY";
        }

        return str;
    }
}
'@
#@'
<#
    by now the results of passing a null reference as the string argument
    should make sense to you:
#>
[Equality]::TestNullString( $null );