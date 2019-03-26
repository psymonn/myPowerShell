###################################################################################################################
##### 115 character width indicator #####
###################################################################################################################

<#
.Synopsis
   Checks if an SCCM boundary has been created correctly.

.DESCRIPTION
    Checks if an SCCM boundary has been created correctly. This function is for use within the following function:
    Create-SCCMBoundary. If a boundary has been created correctly then function returns $true. If the boundary has
    not been created correctly then it returns a $false.

.PARAMETER BoundaryGroupAddedTo
    Name of the boundary group to check if the boundary has been added to it.

.PARAMETER BoundaryName
    Name of the boundary to check if it has been created.

.PARAMETER BoundarySubnetIdCidr
    IP Address in CIDR form of the boundary to check it has been set correctly.

.PARAMETER BoundaryRangeStartIp
    Start IP Address for IP type range of the boundary to check it has been set correctly.

.PARAMETER BoundaryRangeEndIp
    End IP Address for IP type range of the boundary to check it has been set correctly.

.PARAMETER SccmServer
    Name of the SCCM server to run queries against.

.EXAMPLE
    Check-SCCMBoundaryCreate -BoundaryGroupAddedTo 'Test Group' -BoundaryName 'Test - Boundary - 1'
    -BoundarySubnetIdCidr '100.100.100.0/24' -SccmServer 'SCCM01'

    Returns $false if boundary object queries don't return exactly what is input. Returns $true if those queries
    match perfectly, indicating the boundary was created as specified.

.EXAMPLE
    Check-SCCMBoundaryCreate -BoundaryGroupAddedTo 'Test Group' -BoundaryName 'Test - Boundary - 1'
    -BoundaryRangeStartIp '110.110.110.32' -BoundaryRangeEndIp '110.110.110.45' -SccmServer 'SCCM01'

    Returns $false if boundary object queries don't return exactly what is input. Returns $true if those queries
    match perfectly, indicating the boundary was created as specified.

.INPUTS
    System.String

.OUTPUTS
    System.Boolean

#>

function Check-SCCMBoundaryCreate {

    [cmdletbinding()]

    Param(

        [Parameter(Mandatory = $true,
            ParameterSetName = 'Parameter Set IPSubnet'
        )]
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Parameter Set IPRange'
        )]
        [ValidateNotNullOrEmpty()]
        [string] $BoundaryGroupAddedTo,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'Parameter Set IPSubnet'
        )]
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Parameter Set IPRange'
        )]
        [ValidateNotNullOrEmpty()]
        [string] $BoundaryName,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'Parameter Set IPSubnet'
        )]
        [ValidateNotNullOrEmpty()]
        [string] $BoundarySubnetIdCidr,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'Parameter Set IPRange'
        )]
        [ValidateNotNullOrEmpty()]
        [string] $BoundaryRangeStartIp,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'Parameter Set IPRange'
        )]
        [ValidateNotNullOrEmpty()]
        [string] $BoundaryRangeEndIp,

        #Set the default SCCM server to run the query on as the local host
        [ValidateNotNullOrEmpty()]
        [string] $SccmServer = 'EUCDEVSCCM01'

    )

    Write-Verbose -Message "Checking to see if '$BoundaryName' has been created correctly"

    <#
    Confirm with WMI that the boundary object was created correctly. If WMI fails then try a CIM query.
    If both WMI and CIM fail then resort to using SCCM cmdlets.
    If all queries fail then a return an error as verification couldn't be completed.
    #>

    $getWmiBoundary = @{
        Namespace = 'root/sms/site_cas'
        ComputerName = $SccmServer
        Query = "select * from SMS_Boundary where DisplayName = '$BoundaryName'"
    }

    $getWmiBoundaryGroup = @{
        Namespace = 'root/sms/site_cas'
        ComputerName = $SccmServer
        Query = "select * from SMS_BoundaryGroup where Name = '$BoundaryGroupAddedTo'"
    }

    Write-Verbose -Message "Using WMI to query SCCM server $SccmServer."

    try{

        #Store query results for boundary
        $boundaryObject = Get-WmiObject @getWmiBoundary -ErrorAction Stop

        #Query boundary group for Group ID to see if group has a member with matching Boundary ID.
        $boundaryGroupObject = Get-WmiObject @getWmiBoundaryGroup -ErrorAction Stop

        $getWmiBoundaryMembers = @{
            Namespace = 'root/sms/site_cas'
            ComputerName = $SccmServer
            Query = "select * from SMS_BoundaryGroupMembers where BoundaryID = '$($boundaryObject.BoundaryID)'
            AND GroupID = '$($boundaryGroupObject.GroupID)'"
        }

        $boundaryMembers = Get-WmiObject @getWmiBoundaryMembers -ErrorAction Stop

    }catch{

        Write-Verbose -Message "WMI query failed, verifying using CIM."

        try{

            #Inputs to Get-CimInstance are the same as Get-WmiObject
            $boundaryObject = Get-CimInstance @getWmiBoundary -ErrorAction Stop

            #Query boundary group for Group ID to see if group has a member with matching Boundary ID.
            $boundaryGroupObject = Get-CimInstance @getWmiBoundaryGroup -ErrorAction Stop

            $getCimBoundaryMembers = @{
                Namespace = 'root/sms/site_cas'
                ComputerName = $SccmServer
                Query = "select * from SMS_BoundaryGroupMembers where BoundaryID = '$($boundaryObject.BoundaryID)'
                AND GroupID = '$($boundaryGroupObject.GroupID)'"
            }

            $boundaryMembers = Get-CimInstance @getCimBoundaryMembers -ErrorAction Stop

        }catch{



            try{

                $boundaryObject = Get-CMBoundary -BoundaryName $BoundaryName -ErrorAction Stop

                #Check boundary group for required boundary.
                $boundaryMembers = Get-CMBoundary -BoundaryGroupName "$BoundaryGroupAddedTo" -ErrorAction Stop |
                Where-Object -FilterScript { $_.displayname -eq  $BoundaryName}

            }catch{

                Write-Verbose -Message "Verification failed, throwing error."

                [string] $errorMessage = (
                    "Could not confirm '$BoundaryName' was created. " +
                    "Please check that it was created."
                )

                $PSCmdlet.ThrowTerminatingError(
                    [System.Management.Automation.ErrorRecord]::new(
                        ([System.NotImplementedException] $errorMessage),
                        'CreateValidateFailed',
                        [System.Management.Automation.ErrorCategory]::OpenError,
                        $BoundaryName
                    )
                )
            }
        }
    }

    Write-Verbose -Message "$boundaryMembers, $($boundaryObject.DisplayName), $BoundaryName"

    #If the boundary object has been created correctly then return $true otherwise return $false
    if($boundaryMembers -and ($boundaryObject.DisplayName -eq $BoundaryName)){

        Write-Verbose -Message "Boundary name and group has been set correctly, Checking Boundary Values."

        #Boundaries defined by IPSubnets have boundary type 0. If they are defined by IPRanges they have type 3.
        if($pscmdlet.ParameterSetName -eq 'Parameter Set IPSubnet' -and
        $boundaryObject.BoundaryType -eq 0 -and
        (Convert-CIDRToSubnetId -CIDRAddress "$BoundarySubnetIdCidr") -eq $boundaryObject.Value){

            Write-Verbose -Message "Boundary Type is SubnetID and the IP Address has been set up correctly"

            return $true

        }elseif($pscmdlet.ParameterSetName -eq 'Parameter Set IPRange'-and
        $boundaryObject.BoundaryType -eq 3 -and
        ("$($BoundaryRangeStartIp)" + "-" + "$($BoundaryRangeEndIp)")-eq $boundaryObject.Value){

            Write-Verbose -Message "Boundary Type is Range and the IP Address has been set up correctly"

            return $true
        }
        else{

            Write-Verbose -Message "IP Address has not been set up correctly"

            return $false
        }

    }else{

        Write-Verbose -Message "Boundary has not been created correctly, returning false."

        return $false

    }

    Write-Verbose -Message "Verification complete."
}
###################################################################################################################
##### 115 character width indicator #####
###################################################################################################################
