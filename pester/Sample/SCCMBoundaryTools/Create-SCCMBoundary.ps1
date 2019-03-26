###################################################################################################################
##### 115 character width indicator #####
###################################################################################################################
<#
.Synopsis
   Creates a new SCCM boundary object.

.DESCRIPTION
   Creates a new SCCM boundary object and then adds it to a specified boundary group. Boundary objects can be
defined by either a subnet IP in CIDR form or by an IP address range.

.PARAMETER BoundaryGroupToAddTo
    The name of the boundary group that the created boundary will be added to.

.PARAMETER BoundaryName
    The name of the boundary to be created.

.PARAMETER BoundarySubnetIdCidr
    Subnet ID in CIDR form of the boundary to be created. Must include a valid IPv4 address and number of network
bits.

.PARAMETER BoundaryRangeStartIp
    The first IP address of the range of IP addresses to be used to create the boundary. If this value is larger
than the end IP address the function will swap the starting and ending IP address. Must be an IPv4 address.

.PARAMETER BoundaryRangeEndIp
    The last IP address of the range of IP addresses to be used to create the boundary. If this value is smaller
than the starting IP address the function will swap the starting and ending IP address. Must be an IPv4 address.

.EXAMPLE
    Create-SCCMBoundary -BoundaryGroupToAddTo 'Test Group' -BoundaryName 'Test - Boundary - 1' -BoundarySubnetIdCidr '100.100.100.0/24'

    Creates a boundary named 'Test - Boundary - 1' with IPSubnet value '100.100.100.0/24' and adds it to boundary
        group 'Test Group'.

.EXAMPLE
    Create-SCCMBoundary -BoundaryGroupToAddTo 'Test Group' -BoundaryName 'Test - Boundary' -BoundaryRangeStartIp '110.110.110.32' -BoundaryRangeEndIp '110.110.110.45'

    Creates a boundary named 'Test - Boundary - 1' with IPRange value '110.110.110.32-110.110.110.45' and adds it to
        group 'Test Group'.

.EXAMPLE
    Create-SCCMBoundary -BoundaryGroupToAddTo 'Test Group' -BoundaryName 'Test - Boundary' -BoundaryRangeStartIp '10.192.21.123' -BoundaryRangeEndIp '10.192.21.94'

    Given that the ending IP address is smaller than the starting IP address the function will swap the IP addresses
        before creating the boundary. The above example will result in a boundary being created with IPRange value
        '10.192.21.94-10.192.21.123'.

.INPUTS
    Does not accept pipeline input.

.OUTPUTS
    IResultObject#SMS_Boundary

.Notes
    The output is the boundary object that is created.
#>
function Create-SCCMBoundary {

    [CmdletBinding(DefaultParameterSetName = 'Parameter Set IPSubnet')]

    Param (

        [Parameter(Mandatory = $true,
            ParameterSetName = 'Parameter Set IPSubnet'
        )]
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Parameter Set IPRange'
        )]
        [ValidateScript({Check-BoundaryGroupName})]
        [ValidateNotNullOrEmpty()]
        [string] $BoundaryGroupToAddTo,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'Parameter Set IPSubnet'
        )]
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Parameter Set IPRange'
        )]
        [ValidateScript({Check-BoundaryNameNew})]
        [ValidateNotNullOrEmpty()]
        [string] $BoundaryName,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'Parameter Set IPSubnet'
        )]
        [ValidateScript({Check-IPCIDR})]
        [ValidateNotNullOrEmpty()]
        [string] $BoundarySubnetIdCidr,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'Parameter Set IPRange'
        )]
        [ValidateScript({
            Write-Verbose -Message "Validating IP range starting IP address."
            $parameter = "The starting IP"
            Check-IPAddress
        })]
        [ValidateNotNullOrEmpty()]
        [string] $BoundaryRangeStartIp,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'Parameter Set IPRange'
        )]
        [ValidateScript({
            Write-Verbose -Message "Validating IP range ending IP address."
            $parameter = "The ending IP"
            Check-IPAddress
        })]
        [ValidateNotNullOrEmpty()]
        [string] $BoundaryRangeEndIp
    )

    Write-Verbose -Message "Starting function."

    <#
    If Parameter Set IPSubnet is being used then boundaries are defined by IP Subnets so these will be used to
    create boundaries.

    If Parameter Set IPRange is being used then boundaries are defined by IP Ranges so these will be used to
    create boundaries.
    #>

    Write-Debug -Message "BoundaryGroupToAddTo = $BoundaryGroupToAddTo"
    Write-Debug -Message "BoundaryDescription = $BoundaryName"
    Write-Debug -Message "BoundarySubnetIdCidr = $BoundarySubnetIdCidr"
    Write-Debug -Message "BoundaryRangeLowerIp = $BoundaryRangeStartIp"
    Write-Debug -Message "BoundaryRangeUpperIp = $BoundaryRangeEndIp"

    Write-Debug -Message "Parameter Set = $($pscmdlet.ParameterSetName)"

    if($pscmdlet.ParameterSetName -eq 'Parameter Set IPSubnet'){

        Write-Verbose -Message "Creating boundary, $BoundaryName, using subnet ID $BoundarySubnetIdCidr."

        #Parameter Set IPSubnet uses IP subnets to create the boundary.

        #Create the new boundary
        try{

            New-CMBoundary -Name $BoundaryName -Type IPSubnet -Value $BoundarySubnetIdCidr

            $params = @{
            BoundaryGroupAddedTo = $BoundaryGroupToAddTo
            BoundaryName = $BoundaryName
            BoundarySubnetIdCidr = $BoundarySubnetIdCidr
            }

        }catch{

            $lastError = $Error[0]
            <#
            Check to see if the error refers to a an object that already exists.
            Since the name has already been validated then this error is due to a boundary already
            having the same $boundaryValue.
            #>
            if($lastError.ToString() -like "An object with the specified name already exists."){

                [string] $errorMessage = ("Specified boundary object already exists. " +
                    "The following are existing boundaries: ")

                #Append a list of existing boundaries to error message.
                $errorMessage += Get-ExistingSCCMBoundaryErrorMessage

                $PSCmdlet.ThrowTerminatingError(
                    [System.Management.Automation.ErrorRecord]::new(
                        ([System.ArgumentException] "$errorMessage"),
                        'InvalidNumberOfNetworkBits',
                        [System.Management.Automation.ErrorCategory]::OpenError,
                        $userInput
                    )
                )

            }else{

                $PSCmdlet.ThrowTerminatingError($PSItem)

            }

        }

    }elseif($pscmdlet.ParameterSetName -eq 'Parameter Set IPRange'){

        Write-Verbose -Message "Using an IP range to create new boundary."

        #Parameter Set IPRange uses IP ranges to create a new boundary.

        #Makes sure start IP is lower than the end IP and swaps them if not
        $IPRange = Check-IPStartEnd -StartIP "$BoundaryRangeStartIp" -EndIP "$BoundaryRangeEndIp"

        #Combine the lower and upper limits into a singe string to feed into the New-CMBoundary Cmdlet
        [string] $boundaryValue = "$($IPRange[0])" + "-" + "$($IPRange[1])"

        Write-Verbose -Message "Creating boundary `'$BoundaryName`' using IP range $boundaryValue."

        #Create the new boundary
        try{

            New-CMBoundary -Name $BoundaryName -Type IPRange -Value $boundaryValue

            $params = @{
            BoundaryGroupAddedTo = $BoundaryGroupToAddTo
            BoundaryName = $BoundaryName
            BoundaryRangeStartIp = $BoundaryRangeStartIp
            BoundaryRangeEndIp = $BoundaryRangeEndIp
            }

        }catch{

            $lastError = $Error[0]
            <#
            Check to see if the error refers to a an object that already exists.
            Since the name has already been validated then this error is due to a boundary already
            having the same $boundaryValue.
            #>
            if($lastError.ToString() -like "An object with the specified name already exists."){

                [string] $errorMessage = ("Specified boundary object already exists. " +
                    "The following are existing boundaries: ")

                #Append a list of existing boundaries to error message.
                $errorMessage += Get-ExistingSCCMBoundaryErrorMessage

                $PSCmdlet.ThrowTerminatingError(
                    [System.Management.Automation.ErrorRecord]::new(
                        ([System.ArgumentException] "$errorMessage"),
                        'InvalidNumberOfNetworkBits',
                        [System.Management.Automation.ErrorCategory]::OpenError,
                        $userInput
                    )
                )

            }else{

                $PSCmdlet.ThrowTerminatingError($PSItem)

            }

        }

    }


    #Now that a new boundary has been created it needs to be added to a boundary group so that it can be used

    Write-Verbose -Message "Adding boundary $BoundaryName, to boundary group $BoundaryGroupToAddTo."

    try{

        Add-CMBoundaryToGroup -BoundaryName $BoundaryName -BoundaryGroupName $BoundaryGroupToAddTo

    }catch{

        $PSCmdlet.ThrowTerminatingError($PSItem)

    }

    Write-Verbose "Checking boundary object has been created."

    try{

        $hasBeenCreated = Check-SCCMBoundaryCreate @params

    }catch{

        $PSCmdlet.ThrowTerminatingError($PSItem)

    }

    if($hasBeenCreated -eq $false){

        $PSCmdlet.ThrowTerminatingError(
            [System.Management.Automation.ErrorRecord]::new(
                ([System.NotImplementedException] "Boundary '$BoundaryName' was not created correctly."),
                'BoundaryCreateFailed',
                [System.Management.Automation.ErrorCategory]::OpenError,
                $BoundaryName
            )
        )
    }
    Write-Verbose -Message "Function complete."

}
###################################################################################################################
##### 115 character width indicator #####
###################################################################################################################
