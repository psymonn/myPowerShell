# The Pipeline

1 | Select-Object

1, 2 | Measure-Object
1, 2, 3, 4, 5 | Measure-Object -Average -Sum -Maximum -Minimum

# Select-Object can be used to grab just parts of objects

$myVariable = [PSCustomObject] @{ 
    Line1 = "This is"
    Line2 = "a hash table" }
$myVariable | Select-Object Line1

# And %{ is a For Each loop where $_ is whatever is being iterated

1, 2 | %{ 
    "Received $_"
}

foreach ($myNumber in @(1, 2)) {
    "Received $myNumber"
}

# Every member of the pipeline is doing some work on the incoming objects

1,2 | Select-Object -Last 1

# Where-Object is an extremely common and powerful command that takes a block.
# This also shows some comparison operators too, you can't use ==, >, < etc.

1,2 | Where-Object { $_ -eq 1 } # Equal
1,2 | Where-Object { $_ -gt 1 } # Greater than
1,2 | Where-Object { $_ -lt 1 } # Less than

# Now for some other default "variables"

Get-Variable *Ver*

# This variable has our version information

$PSVersionTable

# Environment variables are stored under another
# variable called $env. You can't list them out like this:

$env

# But you can reference them like:

$env:COMPUTERNAME

# PowerShell also emulates a disk for it

Get-PSDrive Env
Dir Env:

# Lots of stuff in PowerShell is like this.

Set-Location Env: # cd
Get-ChildItem     # dir
Set-Item myEnvironmentVariable "Great!"
Dir
C:
# Inspect our variable
$env:myEnvironmentVariable

# Some commands you can execute if they're in your path

ping localhost -n 1

# Or you can run them if you specify their directory

C:\Windows\System32\ping localhost -n 1

# Or you can use variables, too

ping $env:COMPUTERNAME -n 1

# But it's considered polite to put an ampersand in front,
# and also lets you execute programs dynamically too

$myCommand = "ping"
&$myCommand $env:COMPUTERNAME -n 1

# Let's deal with some errors!

$myCommand = "pign"
&$myCommand $env:COMPUTERNAME -n 1

try { 
    &$myCommand $env:COMPUTERNAME -n 1
} catch {
    # $_ is the "last error". It's best to quickly save it.
    $thisError = $_

    # Now we can do anything, or...
    "You're out! Why? $($thisError.Exception.Message)"
}

# But it only works on terminating errors...

Copy-Item Test.txt C:\

try { 
    Copy-Item Test.txt C:\
} catch { 
    "You'll never catch me!"
}

$ErrorActionPreference = "Stop"
try { 
    Copy-Item Test.txt C:\
} catch { 
    "You'll never catch me!"
}

<# You could also:

try { 
    Copy-Item Test.txt C:\ -ErrorAction:Stop
} catch { 
    "You'll never catch me!"
}

#>

## Next slide
