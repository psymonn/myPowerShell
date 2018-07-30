
function Get-DiskSpaceInfo4 {
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
                    HelpMessage='Computer name to query',
                    ValueFromPipeline=$true,       #done 1st# #only one datatype can go through the same pipeline, e.g you can't have two datatype String to through the same pipline, it gets confused.           
                    ValueFromPipelineByPropertyName=$true)]   #done 2nd# #you can have as many perperty to go through the same pipeline, because it not based on the datatype but only parameter name
        [Alias('Hostname')]
        [Alias('Name')]
        [ValidateCount(1,3)]
        #[ValidatePattern('\w+TOP\-N5523PQ')]  #anyword followed by top-n5523pq
        [ValidateLength(1,40)]
        [string[]]$ComputerName,     #first it fine by value and hook it up to string datatype to object $computername
                                     #if it can't find the string datatype $computername then it will look for byPropertyName by inspecting the pipline object and the content name will get hook up by this parameter $computername same name as the datatype

        [Parameter(Position=2,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Floppy', 'Local', 'Optical')]
        [string]$DriveType = 'local'
    )
    
    begin {} #can use begin to do initialisation once e.g connect to the database
    process {#use process to repeat all the process
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
#help about_functions_advanced_parameters
#Get-Content ..\computers.txt |measure
#Get-Content ..\computers.txt |gm -> type string

# PS D:\scripts> import-csv .\comps.csv
# name            type
# ----            ----
# DESKTOP-N5523PQ local
# DESKTOP-N5523PQ local


# PS D:\scripts> import-csv .\comps.csv | select @{n='ComputerName';e={$_.name}},@{n='DriveType';e={$_.type}}
# ComputerName    DriveType
# ------------    ---------
# DESKTOP-N5523PQ local
# DESKTOP-N5523PQ local


#ByValue won't work but byProperty works; see NoteProperty below ComputerName and DriverType
#Try it out ->  PS D:\scripts> import-csv .\comps.csv | select @{n='ComputerName';e={$_.name}},@{n='DriveType';e={$_.type}} |gm
#    TypeName: Selected.System.Management.Automation.PSCustomObject

# Name         MemberType   Definition
# ----         ----------   ----------
# Equals       Method       bool Equals(System.Object obj)
# GetHashCode  Method       int GetHashCode()
# GetType      Method       type GetType()
# ToString     Method       string ToString()
# ComputerName NoteProperty System.String ComputerName=DESKTOP-N5523PQ
# DriveType    NoteProperty System.String DriveType=local

#All Works!
#Test1 -> Get-DiskSpaceInfo4 "$env:COMPUTERNAME"
#Test2 -> import-csv .\comps.csv | select @{n='ComputerName';e={$_.name}},@{n='DriveType';e={$_.type}} |Get-DiskSpaceInfo4
#Test3 -> PS D:\scripts> import-csv .\comps.csv | select @{n='hostName';e={$_.name}},@{n='DriveType';e={$_.type}} |Get-DiskSpaceInfo4

#function works by specify value by parameter or allow them to attach to parmeter by the pipeline