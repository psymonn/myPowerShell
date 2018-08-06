<#
    this one may not seem like a gotcha unless you 
    know another programming language or two...

    take a look at this logical expression, what do you think
    the result of this expression should be?
#>
$true -or $true -and $false

get-content jscript.js
cscript jscript.js

get-content vbscript.vbs
cscript vbscript.vbs

<#
    powershell evaluates this to $false, but almost any other language will evaluate the 
    same expression as $true.  

    see examples in the demo folder for:

    python
    vbscript
    jscript
    C# (ScriptCS)

    the reason has to do with operator precedence.  operator precedence is used to
    determine how a language like PowerShell interprets an order of operations
    from a statement.  Just like in math, it's used to ensure that multiplication 
    evaluates before addition:
#>
2 + 5 * 10
2 + (get-process | measure-object -Property "CPU" -sum).Sum 

# the correct result of this expression is 52, not 70, because multiplication is 
# evaluated before addition

<#
    in powershell, the AND and OR operators
    have identical levels of precedence.  this means that they are evaluated from left-to-
    right.  in most other languages, the AND operator has a higher precedence than the OR
    operator; this means that AND expressions are evaluated before OR expressions
#>

cls

<#
    chances are this logical expression gotcha doesn't bother you, but if it does,
    try using parentheses around expressions to explicitly define the order of 
    operations for PowerShell:
#>
$true -or ($true -and $false)