<#

.SYNOPSIS
Searches for files on local hard disk.

.DESCRIPTION
Searches for files depending on their name and creation timestamps.

.PARAMETER SinceDate
Only files created on or after this date are returned.

.PARAMETER FileTypes
An array of file matching strings to search for.

.EXAMPLE
Get-FilesByExtension "2014-07-20" "*.txt"

.NOTES
Modification History

Date        By			Description
2014-07-21  C Konior    New.

#>
function Get-FilesByExtension {
    [CmdletBinding()] 
    Param(
        [parameter(Mandatory = $true)]
        $SinceDate, 
        [parameter(Mandatory = $true)]
        $FileMatchingStrings,
        $VerboseOverride = $false
    )
    Set-StrictMode -Version Latest

    if ($VerboseOverride) {
        $VerbosePreference = "Continue"
    }

    Get-WmiObject Win32_LogicalDisk | Where DriveType -eq 3 | Select-Object -ExpandProperty DeviceID | 
        Join-Path -ChildPath "\" | %{
            $driveRoot = $_
        
            Write-Verbose "Scanning $driveRoot on $($env:COMPUTERNAME) for files like $($FileMatchingStrings) since $($SinceDate.ToString())"
            Get-ChildItem $driveRoot -Include $FileMatchingStrings -Recurse -ErrorAction:SilentlyContinue | Where {
                    $_.CreationTime -ge $SinceDate
                } | Select -Property *
                # This is done to preserve all the properties. If we ran this exact
                # same function remotely, the output gets changed a little unless
                # we specify this.
        }
}
