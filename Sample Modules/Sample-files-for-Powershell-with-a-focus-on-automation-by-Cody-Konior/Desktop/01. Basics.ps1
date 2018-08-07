# Run as Administrator ...

# Update-Help

# This is a common command format; Verb-Noun

Get-Help
Get-Verb
Get-Command

# We need a temporary file to test with. 

Set-Content -Path "Test.txt" -Value "This is a test"

# PS: Want to know what other commands are like this? 

Get-Help *-Content

# Some common DOS commands have aliases

Type Test.txt                 # Get-Content
Dir Test.txt                  # Get-ChildItem
Copy Test.txt Test2.txt       # Copy-Item
Del Test.txt                  # Remove-Item
Move Test2.txt Test.txt       # Move-Item

# But be careful, the original switches aren't usually supported

dir Test.txt /s

# You have to use the switch for the equivalent PowerShell command

dir Test.txt -Recurse

# Take a look at the alias list

Get-Alias

# Or specific entries... * is a wildcard

Get-Alias *D*

# Okay let's write something to the file...

Set-Content "Test.txt" "This is a test"

# Notice we didn't use the same parameter names as before?
# Parameters can be set on position alone.

Help Set-Content -ShowWindow

# These are line-based comments

<# 
    This is a block comment
#>

"This is a string"

$myVariable = "This is a variable"

# We can include variables within strings...

"This is a variable $myVariable"

# Or not ...

'This is a variable too $myVariable'

# Backticks are an escape character

"This is a variable too `$myVariable"
'This is a variable too `$myVariable'

# Back ticks can continue a line

"I am `
more than one line"

# Though the proper practice is this
# Be careful about the @"

@"
I am
more than one line
"@ # Comments are okay here

# This variable could be a number instead

$myVariable = 1
"$myVariable + 1"

# What if we wanted to really do it? Wrap it in $()

"$($myVariable + 1)"

# Want to know what variables have been defined?

Get-Variable

# This is a block of executable code

{ 
    1 + 1
}

# But it doesn't do anything by itself
# Unless you use a dot

. { 1 + 1 }

# Or an ampersand

& { 1 + 1 }

# But they're not equivalent

$myVariable = 1
. { $myVariable += 1 }
"myVariable is now $myVariable"
& { $myVariable += 1 }
"myVariable is now $myVariable"

# You can turn a string into a block and execute it. Like dynamic SQL!

$myVariable = [ScriptBlock]::Create("1 + 1")

# Just to prove it really hasn't evaluated yet...

$myVariable

# And then run it...

&$myVariable

# Oh yeah ever variable is pretty much interchangeable with a .NET
# object. Which means you can cast them, or call methods on them.

([int] "1").GetType()
([int] "1").ToString().GetType()

# This is an array, PowerShell automatically shows each 
# segment on one line

"What about","an array?"

# Proof

("What about","an array?").GetType()

# This is also an array if you want to be explicit about it.

@("What about","an array?")

# This is a hash table

@{ Line1 = "This is"
   Line2 = "a hash table" }

$myVariable = @{ Line1 = "This is"
   Line2 = "a hash table too" }
$myVariable

# This is retrieving a value from the hash table

$myVariable["Line1"]

# This looks kind of stupid but it's called splatting

$myVariable = @{
    Path = "C:\Temp\Test.txt"
    Value = "Hi"
} 

Set-Content @myVariable
# Set-Content -Path "C:\Temp\Test.txt" -Value "Hi"

Get-Content C:\Temp\Test.txt

# This creates a special .NET object in PowerShell 3 where the 
# hash table becomes properties, in order

$myVariable = [PSCustomObject] @{ 
    Line1 = "This is"
    Line2 = "a hash table" }
$myVariable
$myVariable.Line1

# Be careful with dates, they are represented internally as US format

$myVariable = [DateTime] "2014-07-23"
$myVariable
$myVariable.ToString()
"Oops: $myVariable"
"Use this instead: $($myVariable.ToString())"


## Next slide
