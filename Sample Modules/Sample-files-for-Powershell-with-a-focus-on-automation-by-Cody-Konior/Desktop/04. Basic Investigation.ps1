# This is silly, but let's create a super long path until it breaks.
# Broken version start (run this entire block)

    # Preparation
    # Revert to defaults
    Set-StrictMode -Off
    # Clean up past runs
    rd "C:\Temp\1234567890" -Recurse

    $directoryName = "C:\Temp"
    $subDirectoryName = "1234567890"

    try {
        while ($true) {
            $directoryName = Join-Path $directoryName $subDirectoryName
            ##
            md $directoryName ##
        }
    } catch {
        "We got up to $directoyName" ##
        rd "C:\Temp\$subDirectoryName" -Recurse
    }

# Broken version end

<#

It has three intentional errors.
1. It runs forever instead of quitting because the failure of md is
   not a terminating error. Set $ErrorActionPreference or use switch
   parameter -ErrorAction:Stop.
2. It writes information to screen we don't want to see (for each
   time it makes a directory). We can hide this with | Out-Null, or,
   a faster method is sticking a [void] at the front (casting it to
   a null type).
3. The catch statement does not print the directory name because 
   $directoyName does not exist and if we are not running in Strict
   Mode, PowerShell doesn't warn us. By setting Strict Mode, we can
   see we've made a typo, and fix it.
    
#>

# Fixed version start (run this entire block)

    # Preparation
    Set-StrictMode -Version Latest
    # Clean up past runs
    rd "C:\Temp\1234567890" -Recurse

    $directoryName = "C:\Temp"
    $subDirectoryName = "1234567890"

    try {
        while ($true) {
            $directoryName = Join-Path $directoryName $subDirectoryName
            md $directoryName -ErrorAction:Stop | Out-Null
        }
    } catch {
        "We got up to $directoryName"
        rd "C:\Temp\$subDirectoryName" -Recurse
    }

# Fixed version end

# Now let's look at working with objects

$myVariable = Get-ChildItem C:\Windows

# What do we have?

$myVariable.GetType()
$myVariable.Count
$myVariable | Measure-Object
$myVariable[0].GetType()

# Get-Member is extremely important command for finding information

$myVariable | Get-Member 

# Notice that it unpacked our array to tell us what's inside.
# If we wanted to know what just an array can do...

Get-Member -InputObject $myVariable

# Let's say, we want the filename.

$myVariable
$myVariable.Name

# No, we want the full name. What's it called?

$myVariable | Get-Member *Path*
$myVariable | Get-Member *Name*

# Here they are.

$myVariable.FullName

# There's some special handling with arrays where it can work out
# what you want and grab all the individual properties like that.
# But it might not always work well that way, so a better way is:

$myVariable | Select-Object -Property FullName

# And that Select-Object isn't limited to one property. It takes
# an array of properties.

$myVariable | Select-Object -Property FullName, Extension

# Select-Object lets us add our own own properties with a hash table...

$myVariable | Select-Object -Property FullName, 
    Extension, 
    @{ Name = "Just Extension"; Expression = { $_.Extension.Substring(1) } } 

# And then pipe them on and work on that...

$myVariable | Select-Object -Property FullName, 
    Extension, 
    @{ Name = "Just Extension"; Expression = { $_.Extension.Substring(1) } } |
    Sort-Object -Property "Just Extension" -Descending

# How can we determine if any of those objects are directories?
# First, how could we grab the C:\Windows directory, instead of what's inside it?
# To the help...

Get-Help Get-ChildItem -ShowWindow

# Okay let's pass a path and a filter

Get-ChildItem C:\ Windows

# What is it?

Get-ChildItem C:\ Windows | Get-Member

# How can we test it? -eq -ne -le -gt -like -is

Get-ChildItem C:\Windows | 
    Where-Object { $_ -is [System.IO.DirectoryInfo] }
Get-ChildItem C:\Windows | 
    Where-Object { $_ -isnot [System.IO.DirectoryInfo] }

# ! is also supported ...

Get-ChildItem C:\Windows | 
    Where-Object { ! ($_ -is [System.IO.DirectoryInfo]) }

# But we can use the -Directory option, we don't need to do it manually.

# What's the longest path on disk that doesn't have any files in it?

Get-ChildItem C:\ -Recurse -Directory -ErrorAction:SilentlyContinue | 
    Sort-Object { $_.FullName.Length } -Descending | 
    Where-Object { 
        (Get-ChildItem $_.FullName -File | Measure-Object).Count -eq 0
        } | 
    Select-Object -First 1 

## Demo before next slide
