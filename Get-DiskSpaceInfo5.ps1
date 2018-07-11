
function Get-DiskSpaceInfo5 {

    [CmdletBinding()]
    param (
        [Parameter (Mandatory=$true,
                    ParameterSetName="Info",
                    Position=1,
                    HelpMessage='Computer name to query',
                    ValueFromPipeline=$true, 
                    ValueFromPipelineByPropertyName=$true)]
        [Alias('Hostname')]
        [Alias('Name')]
        [ValidateCount(1,3)]
        [ValidateLength(1,40)]
        [string[]]$ComputerName,     
                                     

        [Parameter(Position=2,
                   ParameterSetName="Info",
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Floppy', 'Local', 'Optical')]
        [string]$DriveType = 'local',

        [Parameter(ParameterSetName="List")]
        [switch]$ListDrivesOnly

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

#ByValue won't work but byProperty works; see NoteProperty below ComputerName and DriverType
# GetType      Method       type GetType()
# ToString     Method       string ToString()
# ComputerName NoteProperty System.String ComputerName=ComputerName
# DriveType    NoteProperty System.String DriveType=local