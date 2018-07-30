
function Get-DiskSpaceInfo3 {
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
 help about_functions_advanced_parameters
#>
    [CmdletBinding()]
    param (
        [Parameter (Mandatory=$true,
                    Position=1,
                    HelpMessage='Computer name to query')]
        [Alias('Hostname')]
        [ValidateCount(1,3)]
        #[ValidatePattern('\w+TOP\-N5523PQ')]  #anyword followed by top-n5523pq
        [ValidateLength(1,40)]
        [string[]]$ComputerName,

        [Parameter(Position=2)]
        [ValidateSet('Floppy', 'Local', 'Optical')]
        [string]$DriveType = 'local'
    )
    
    begin {}
    process {
        foreach ($Computer in $ComputerName){
            $params = @{'ComputerName'=$Computer;
                        'class' = 'win32_logicalDisk'}
            switch ($DriveType) {
                'Local' {$params.Add('Filter', 'DriveType=3'); break}
                'Floppy' {$params.Add('Filter', 'DriveType=2'); break}
                'Optical' {$params.Add('Filter', 'DriveType=5'); break}

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

#remove-module diskspaceinfo
#Get-DiskSpaceInfo2
#help about_functions_advanced_parameters