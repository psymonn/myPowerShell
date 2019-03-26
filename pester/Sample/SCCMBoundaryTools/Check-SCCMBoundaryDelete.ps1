###################################################################################################################
##### 115 character width indicator #####
###################################################################################################################

<#
.Synopsis
   Checks if an SCCM boundary has been deleted correctly.

.DESCRIPTION
    Checks if an SCCM boundary has been deleted. This function is for use within the following function:
    Delete-SCCMBoundary. If a boundary has been deleted then function returns $true. If the boundary has not been
    deleted then it returns a $false.

.PARAMETER BoundaryName
    Name of the boundary to check if it has been deleted.

.PARAMETER SccmServer
    Name of the SCCM server to run queries against.

.EXAMPLE
    Check-SCCMBoundaryDelete -BoundaryName 'Test' -SccmServer 'SCCM01'

    Returns $false if boundary object queries return an object named 'Test'. Returns $true if those queries do not
    return a boundary object indicating that the boundary has been deleted.

.INPUTS
    System.String

.OUTPUTS
    System.Boolean

#>

function Check-SCCMBoundaryDelete {

    [cmdletbinding()]

    param(

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $BoundaryName,

        #Set the default SCCM server to run the query on as the local host
        [ValidateNotNullOrEmpty()]
        [string] $SccmServer = 'localhost'

    )

    Write-Verbose -Message "Checking to see if '$BoundaryName' has been deleted."
    <#
    Confirm with WMI that the boundary object was deleted. If WMI fails then try a CIM query.
    If both WMI and CIM fail then resort to using SCCM cmdlets.
    If all queries fail then a return an error as verification couldn't be completed.
    #>

    $getWmiSplat = @{
        Namespace = 'root/sms/site_cas'
        ComputerName = $SccmServer
        Query = "select * from SMS_Boundary where DisplayName = '$BoundaryName'"
    }


    try{

        Write-Verbose -Message "Using WMI to query SCCM server $SccmServer."

        $boundaryObject = Get-WmiObject @getWmiSplat -ErrorAction Stop

    }catch{

        try{

            Write-Verbose -Message "WMI query failed, verifying using CIM."

            #Inputs to Get-CimInstance are the same as Get-WmiObject
            Get-CimInstance @getWmiSplat -ErrorAction Stop

        }catch{

            try{

                Write-Verbose -Message "CIM query failed, verifying using SCCM cmdlets."

                $boundaryObject = Get-CMBoundary -BoundaryName $BoundaryName -ErrorAction Stop

            }catch{

                Write-Verbose -Message "Verification failed, throwing error."

                [string] $errorMessage = (
                    "Could not confirm '$BoundaryName' was deleted. " +
                    "Please check that it was deleted."
                )

                $PSCmdlet.ThrowTerminatingError(
                    [System.Management.Automation.ErrorRecord]::new(
                        ([System.NotImplementedException] $errorMessage),
                        'DeleteValidateFailed',
                        [System.Management.Automation.ErrorCategory]::OpenError,
                        $BoundaryName
                    )
                )
            }
        }
    }

    #If the boundary object exists, then return $false otherwise return $true if the object has been deleted
    if($boundaryObject){

        Write-Verbose -Message "Boundary has not been deleted, returning false."

        return $false

    }else{

        Write-Verbose -Message "Boundary has been deleted, returning true."

        return $true

    }

    Write-Verbose -Message "Verification complete."
}
