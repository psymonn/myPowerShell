###################################################################################################################
##### 115 character width indicator #####
###################################################################################################################
<#
.Synopsis
   Checks if the listed start IP address is less than the end IP address.

.DESCRIPTION
    Takes in the IP address range listed when creating or modifying a Boundary and checks whether the start is less
    than the end, then swaps them if it is not.

.PARAMETER StartIP
    The IP Range start address.

.PARAMETER EndIP
    The IP Range end address.

.EXAMPLE
    Check-IPStartEnd -StartIP '192.168.1.10' -EndIP '192.168.1.1'

    Checks if "192.168.1.10" is less than "192.168.1.1" and swaps them if not true. Then returns both in an array
    with the lower address first.

.INPUTS
    Does not accept pipeline input.

.OUTPUTS
    System.String

#>
function Check-IPStartEnd{

    Param (
        [ValidateNotNullOrEmpty()]
        [string] $StartIP,

        [ValidateNotNullOrEmpty()]
        [string] $EndIP
    )
    Write-Verbose -Message "Checking BoundaryRangeLowerIp is less than or equal to BoundaryRangeUpperIp."

    #Check that $StartIp is less than or equal to $EndIp, if not swap them.

    [int[]] $startIpOctets = $StartIp -split('\.')

    Write-Debug -Message "Lower range IP octets = $startIpOctets"

    [int[]] $endIpOctets = $EndIp -split('\.')

    Write-Debug -Message "Upper range IP octets = $endIpOctets"

    #Checks First Octet
    if($startIpOctets[0] -gt $endIpOctets[0]){

        Write-Verbose "Swapping BoundaryRangeLowerIp and BoundaryRangeUpperIp."

        $tempVariable = $StartIp

        $StartIp = $EndIp

        $EndIp = $tempVariable

    #Checks Second Octet
    }elseif(($startIpOctets[0] -eq $endIpOctets[0]) -and ($startIpOctets[1] -gt $endIpOctets[1])){

        Write-Verbose "Swapping BoundaryRangeLowerIp and BoundaryRangeUpperIp."

        $tempVariable = $StartIp

        $StartIp = $EndIp

        $EndIp = $tempVariable

    #Checks Third Octet
    }elseif(($startIpOctets[0] -eq $endIpOctets[0]) -and ($startIpOctets[1] -eq $endIpOctets[1]) -and `
    ($startIpOctets[2] -gt $endIpOctets[2])){

        Write-Verbose "Swapping BoundaryRangeLowerIp and BoundaryRangeUpperIp."

        $tempVariable = $StartIp

        $StartIp = $EndIp

        $EndIp = $tempVariable

    #Checks Fourth Octet
    }elseif(($startIpOctets[0] -eq $endIpOctets[0]) -and ($startIpOctets[1] -eq $endIpOctets[1]) -and `
    ($startIpOctets[2] -eq $endIpOctets[2]) -and ($startIpOctets[3] -gt $endIpOctets[3])){

        Write-Verbose "Swapping BoundaryRangeLowerIp and BoundaryRangeUpperIp."

        $tempVariable = $StartIp

        $StartIp = $EndIp

        $EndIp = $tempVariable
    }

    Write-Debug "BoundaryRangeLowerIp = $StartIP"

    Write-Debug "BoundaryRangeUpperIp = $EndIP"
    return @($StartIP,$EndIP)
}
