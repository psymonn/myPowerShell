<#

.SYNOPSIS
Creates an SQLConnection object or results from an SQL query.

.DESCRIPTION

.PARAMETER InstanceName
Server\Instance name for connection.

.PARAMETER DatabaseName

.PARAMETER UserName 
If blank, a trusted connection is used.

.PARAMETER Password

.PARAMETER MessageVariableName
The name of a global variable to receive the message output from any work done on the returned connection. If it does not exist, it will be created. If a SelectCommand was provided this variable will be cleared before the select is run.

.PARAMETER SelectCommand
A command to run, which will populate a DataSet.

.PARAMETER TableMapping
An array of table names, in order, to use to populate a DataSet. If none is specific then tables are named Table, Table1, Table2, etc.

.EXAMPLE
$resultSet = Connect-SqlServer -InstanceName "APP1" -SelectCommand "SELECT * FROM dbo.Blah"

.NOTES
If a SelectCommand is provided, an SQLCommandBuilder will be added to the adapter, but that part may silently fail if more than one table was selected, etc. You can use -Debug to see the failures.

Modification History

Date        By			Description
2014-07-21  C Konior    New.

#>
function Connect-SqlServer {
    [CmdletBinding()]
    Param( 
        $InstanceName,
        $DatabaseName = "master",
        $UserName = "",
        $Password = "",
        $MessageVariableName = "infoMessage",
        $SelectCommand = "",
        $TableMapping = @()
    )
    Set-StrictMode -Version Latest

    if (Test-Path variable:global:$MessageVariableName) {
        ($messageVariable = Get-Variable -Scope "Global" -Name $MessageVariableName).Value = @()
    } else {
        New-Variable -Scope Global -Name $MessageVariableName
    }

    $sqlDataAdapterError = $null

    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection
    $sqlConnection.ConnectionString = "Data Source=$InstanceName;Initial Catalog=$DatabaseName;"
    $sqlConnection.ConnectionString += if ($UserName -eq "") { "Integrated Security=SSPI;" } else { "User Id=$Username;Password=$Password;" }

    $sqlConnection.add_InfoMessage([ScriptBlock]::Create(@" 
        Param (`$sender, `$event)
        Set-StrictMode -Version Latest

        `$messageVariable = [ref] @()
        if (Test-Path variable:global:$MessageVariableName) {
            `$messageVariable = Get-Variable -Scope "Global" -Name $MessageVariableName -ErrorAction:Stop
        } 

        `$event.Errors | %{
            `$messageVariable.Value += `$_
            "Msg {0}, Level {1}, State {2}, Line {3}`n{4}" -f `$_.Number, `$_.Class, `$_.State, `$_.LineNumber, `$_.Message | Write-Debug
        }
"@))

    if ($SelectCommand -ne "") {
        $dataSet = New-Object System.Data.DataSet
        $sqlDataAdapter = New-Object System.Data.SqlClient.SqlDataAdapter($SelectCommand, $sqlConnection)

        $tableNumber = $null
        $TableMapping | %{
            [void] $sqlDataAdapter.TableMappings.Add("Table$tableNumber", $_)
            $tableNumber += 1
        }

        try {
            [void] $sqlDataAdapter.FillSchema($dataSet, [System.Data.SchemaType]::Mapped)
            [void] $sqlDataAdapter.Fill($dataSet)
        } catch {
            $sqlDataAdapterError = $_
        }

        <#
        $dataSet.ExtendedProperties["ConnectionString"] = $sqlConnection.ConnectionString
        $dataSet.ExtendedProperties["SelectCommand"] = $SelectCommand
        #>

        try {
            $commandBuilder = New-Object System.Data.SqlClient.SqlCommandBuilder($SqlDataAdapter)
            [void] $commandBuilder.GetUpdateCommand()
            [void] $commandBuilder.GetInsertCommand()
            [void] $commandBuilder.GetDeleteCommand()
        } catch { 
            Write-Debug "No SQLCommandBuilder was possible: $_"
        }
    } else {
        $sqlDataAdapter = $null
        $dataSet = $null
    }

    [PSCustomObject] @{
        Connection = $sqlConnection
        Adapter = $sqlDataAdapter
        DataSet = $dataSet
        Messages = (Get-Variable -Scope Global -Name $MessageVariableName).Value
        Errors = $sqlDataAdapterError
        Success = if ($sqlDataAdapterError -eq $null) { $true } else { $false }
    }
}
