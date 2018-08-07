## Final demo for this section

# PowerShell is a lot like Unix in that you're combining lots of little tools 
# designed to work together to process information.

# Let's say I want to find backup files stored on local disks after a certain
# date. Step 1: Identify local disks.

Get-PSDrive

# Sadly we have to query WMI to work this out properly.

Get-WmiObject Win32_LogicalDisk | Where DriveType -eq 3

# After that it's just a matter of joining the stuff we want together

$sinceDate = "2014-07-20"
$backupFileTypes = @("*.bak", "*.bck")

Get-WmiObject Win32_LogicalDisk | Where DriveType -eq 3 | Select-Object -ExpandProperty DeviceID | 
    Join-Path -ChildPath "\" | %{
        $driveRoot = $_
        
        Get-ChildItem $driveRoot -Include $backupFileTypes -Recurse -ErrorAction:SilentlyContinue | Where {
            $_.CreationTime -ge $sinceDate
        } 
    }

## Next slide
