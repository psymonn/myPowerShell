<#

.SYNOPSIS
Searches servers for files.

.DESCRIPTION
By default this cmdlet searches for backup files on all of
our servers that were created in the past week.

.PARAMETER SinceDate
Created on or after this date.

.PARAMETER FileMatchingStrings
An array of patterns that will match the needed file names.

.PARAMETER Servers
An array of servers to search.

.EXAMPLE
Search-FilesOnServers

.NOTES
This always includes the current PC!

Modification History

Date        By			Description
2014-07-21  C Konior    New.

#>
function Search-FilesOnServers {
    [CmdletBinding()]

    Param(
        $SinceDate = (Get-Date).AddDays(-7),
        $FileMatchingStrings = @("*.bak", "*.bck"),
        $Servers = @("DC1", "EX1", "APP1")
    )

    $results = @()

    $results += Get-FilesByExtension $SinceDate $FileMatchingStrings | 
        Select-Object -Property *, @{ Name = "PSComputerName"; Expression = { $env:COMPUTERNAME } }, 
                                   @{ Name = "RunspaceId"; Expression = { [System.Management.Automation.Runspaces.Runspace]::DefaultRunSpace.InstanceId.Guid } } 

    $results += Invoke-Command $Servers ${function:Get-FilesByExtension} -ArgumentList $SinceDate, $FileMatchingStrings

    $results
}
