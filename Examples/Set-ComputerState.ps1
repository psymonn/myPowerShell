function Set-ComputerState{
    [CmdletBinding()]
    Param(
            [Parameter(Mandatory=$True,
                    ValueFromPipeline=$True,
                    ValueFromPipelineByPropertyName=$True)]
            [String[]]$ComputerName,
            [Switch]$Force,

            [Parameter(ParameterSetName='Logoff')]
            [Switch]$LogOff,

            [Parameter(ParameterSetName='Restart')]
            [Switch]$Restart,

            [Parameter(ParameterSetName='Shutdown')]
            [Switch]$Shutdown,

            [Parameter(ParameterSetName='PowerOff')]
            [Switch]$PowerOff
        )]

    )

    PROCESS{
        foreach($computer in $computername){
            $os = Get-WmiObject -ComputerName $computer -Class Win32_OperatingSystem
            if ($logOff) {$arg = 0}
            if ($Restart) {$arg = 2}
            if ($Shutdown) {$arg = 1}
            if ($PowerOff) {$arg = 8}
            if ($Force) {$arg +=4}
            $os.win32Shutdown($arg)

        }

    }    


}