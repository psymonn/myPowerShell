# Basic IO (you can't just "wait for a keypress" though)

$myInput = Read-Host "Tell me anything"

# Saying nothing is like Write-Output

$myInput
Write-Host $myInput      # It's a lot like PRINT
Write-Output $myInput    # It's a lot like SELECT

# It's a lot like the difference between PRINT and SELECT.

$myOutput = Write-Host $myInput
"myOutput is: $myOutput" # Blank
$myOutput = Write-Output $myInput
"myOutput is: $myOutput" # Not on your life

$myInput | Clip
&notepad

# We'll write out all the files in our Windows directory into a CSV

$myFiles = Get-ChildItem C:\Windows
$myFiles | Measure-Object
$myFiles | ConvertTo-Csv | Set-Content C:\Temp\MyWindowsFiles.csv

# It has a lot of columns...

&notepad C:\Temp\MyWindowsFiles.csv

# Oh no, we lost it

$myFiles = $null

# We can recreate it

$myFiles = Get-Content C:\Temp\MyWindowsFiles.csv | ConvertFrom-Csv 

# Manipulate it, writing out just the columns we want

$myFiles | Select-Object -Property Name, Attributes | ConvertTo-Csv | Set-Content C:\Temp\MyWindowsFiles.csv

# That's better

&notepad C:\Temp\MyWindowsFiles.csv

# If we wanted to do XML we have to jump through a few more hoops
# This is a fully serialized .NET object stored to a file. We have
# an Import-CliXml cmdlet too.

$myFiles | Select-Object -Property Name, Attributes | Export-CliXml C:\Temp\MyWindowsFiles.xml

&notepad C:\Temp\MyWindowsFiles.xml

# We also have a ConvertTo-Xml but it returns an XML type. We can
# however grab a string property of that type, and pipe it to a file.

$myFiles | Select-Object -Property Name, Attributes | 
    ConvertTo-Xml | 
    Select-Object -ExpandProperty OuterXml | 
    Set-Content C:\Temp\MyWindowsFiles.xml

&notepad C:\Temp\MyWindowsFiles.xml

## Next Part, Basic Investigation
