# What you get in the box

Import-Module SQLPS -DisableNameChecking

# An irritating path change... sometimes.

Dir

# Only local discovery

Dir SQL
Dir SQL\CLIENT1

# This works

cd SQL\APP1\DEFAULT

Dir Logins

Dir Logins | Select *

Dir DATABASES

Dir DATABASES -Force

Dir DATABASES\master\Users

# But you can't change much (you can start/stop agent jobs, but it doesn't work)

Set-Item Anything $true

cd \

## Change network connection

# And it requires your account to have WMI authentication

Dir SQL\INET1\DEFAULT

## Change network connection

# What about querying data?

C:

# This works great!

$myVariable = Invoke-SqlCmd -Server APP1 "Select * From sys.syslogins"
$myVariable | Select -First 1

# This, not so much

$sqlCommand = "Select * From sys.syslogins; Select * From sys.dm_exec_sessions; Print 'Hi'"

$myVariable = Invoke-SqlCmd -Server APP1 $sqlCommand
$myVariable | Select -First 1
$myVariable | Select -Last 1

# This disappears

Invoke-SqlCmd -Server APP1 "Print 'Hi'"

# Until you do this (even then sometimes it doesn't work)

Invoke-SqlCmd -Server APP1 "Print 'Hi'" -Verbose

# You can't trap Verbose output

$myVariable = Invoke-SqlCmd -Server APP1 "Print 'Hi'" -Verbose
$myVariable

# Or you can ...

$myVariable = Invoke-SqlCmd -Server APP1 "Print 'Hi'" -Verbose 4>&1
$myVariable

# But there are still bugs

$myVariable = Invoke-SqlCmd -Server APP1 "Print 'Hi'" -Verbose -IncludeSqlUserErrors 4>&1

# Roll your own .NET alternative

$resultSet = Connect-SqlServer -InstanceName "APP1" -SelectCommand $sqlCommand -TableMapping "Logins", "Sessions"

$resultSet

$resultSet.DataSet.Tables["Logins"] | Where sysadmin -eq 1

$resultSet.DataSet.Tables["Sessions"] | Where host_name -eq "CLIENT1"

# How about updating tables? You can do it manually with ADO.NET, generate code, or SqlBulkCopy. I'll use SqlCommandBuilder.

<#
    Create Table dbo.Blah (
	    BlahId int identity (1, 1) Constraint PK_Blah Primary Key,
	    Document varbinary(max)
    )

    Insert	dbo.Blah
    Select	0x01
#>

$resultSet = Connect-SqlServer -InstanceName "APP1" -SelectCommand "SELECT * FROM dbo.Blah"
$resultSet.DataSet.Tables[0]

# Add a row

$newRow = $resultSet.DataSet.Tables[0].Rows.Add()
$newRow.Document = [byte[]] 0x12
[void] $resultSet.Adapter.Update($resultSet.DataSet)

# Check the DataSet in memory

$resultSet.DataSet.Tables[0]

# Confirm

$resultSet = Connect-SqlServer -InstanceName "APP1" -SelectCommand "SELECT * FROM dbo.Blah"
$resultSet.DataSet.Tables[0]

# Delete all rows

$resultSet.DataSet.Tables[0].Rows | %{ $_.Delete() } 
[void] $resultSet.Adapter.Update($resultSet.DataSet)

# Confirm

$resultSet = Connect-SqlServer -InstanceName "APP1" -SelectCommand "SELECT * FROM dbo.Blah"
$resultSet.DataSet.Tables[0]


