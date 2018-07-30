
function Get-DiskSpaceInfo2 {
<#
.SYNOPSIS
Retrieve basic disk capacity informtion from one to more computers.
.DESCRIPTION
See the synopsis. This isn't coplex. Noe that this command usesd WWI, not CIM, to connect to remote computer
.PARAMETER ComputerName
One or more cmputer names, or ip address to query
For example:
Get-DiskSpaceInfo -ComputerName one, two, thre
.PARAMETER localOnly
Specifiy this to include only local disks in the output.
This is on by default. To turn it off:
Get-DiskSpaceInfo -ComputerName CLIENT -LocalOnly:$false
.EXAMPLE
Get-DiskspaceInfo -ComputerNme ONE,TOW
This exmaple retrieves disk space info from computer ONE and TWO
.EXAMPLE
Get-DiskSpaceInfo -computerName 192.168.4.4
This example retireves disk space info from a  computer this is specified by IP address
.LINK 
http://bing.com
.LINK 
Get-Content

 see help about_comment_based_help
 see help about_functions_advanced_parameters
#>
    [CmdletBinding()]
    param (
        [Parameter (Mandatory=$true)]
        [string[]]$ComputerName,

        [Parameter()]
        [switch]$localOnly = $true
    )
    
    begin {}
    process {
        foreach ($Computer in $ComputerName){
            $params = @{'ComputerName'=$Computer;
                        'class' = 'win32_logicalDisk'}
            if ($localOnly) {
                $params.Add('Filter', 'DriveType=3')
            }
            Get-WmiObject @params |
            Select-Object -Property @{n='Computer'; e={$_._SERVER}},
                         @{n='Drive'; e={$_.DeviceID}}, 
                         @{n='Size(GB)'; e={"{0:N2}" -f ($_.size / 1GB)}},
                         @{n='FreeSpace(GB)' ; e={"{0:N2}" -f ($_.FreeSpace / 1GB)}},
                         @{n='FreePercent (%)';  e={"{0:N2}" -f ($_.FreeSpace / $_.Size * 100)}},
                         PSComputerName
                         
                                                         
        }       
    } 
    end {}
}


Get-DiskSpaceInfo2 DESKTOP-N5523PQ