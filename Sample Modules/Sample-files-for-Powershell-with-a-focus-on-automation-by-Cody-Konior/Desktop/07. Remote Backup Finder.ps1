# We want to search this computer, DC1, and EX1 for backups.
# So here's a function...

Set-StrictMode -Version Latest # <--- !!!!

function Get-FilesByExtension (
    $SinceDate, 
    $FileMatchingStrings = @("*.bak", "*.bck") # This is what a default looks like...
    ) {
    Set-StrictMode -Version Latest

    Get-WmiObject Win32_LogicalDisk | Where DriveType -eq 3 | Select-Object -ExpandProperty DeviceID | 
        Join-Path -ChildPath "\" | %{
            $driveRoot = $_
        
            Write-Host "Scanning $driveRoot on $($env:COMPUTERNAME) for files like $($FileMatchingStrings) since $SinceDate"
            Get-ChildItem $driveRoot -Include $FileMatchingStrings -Recurse -ErrorAction:SilentlyContinue | Where {
                    $_.CreationTime -ge $SinceDate
                } | Select-Object -Property *
                # This is done to preserve all the properties. If we ran this exact
                # same function remotely, the output gets changed a little unless
                # we specify this.
        }
}

$serverNames = @("DC1", "EX1", "APP1")
$sinceDate = "2014-07-20"
$results = @()

# Note that we wouldn't use a comma between parameters here...

$results += Get-FilesByExtension $sinceDate @("*.bak", "*.bck", "*.txt") | Select-Object -Property *, @{ Name = "PSComputerName"; Expression = { $env:COMPUTERNAME } }, @{ Name = "RunspaceId"; Expression = { [System.Management.Automation.Runspaces.Runspace]::DefaultRunSpace.InstanceId.Guid } } 

# But we would use a comma between parameters here because it takes them as an array

$results += Invoke-Command $serverNames ${function:Get-FilesByExtension} -ArgumentList $sinceDate, @("*.bak", "*.bck", "*.txt")

# What did we find?

$results | Select-Object -Property PSComputerName, FullName, CreationTime

## Next slide
