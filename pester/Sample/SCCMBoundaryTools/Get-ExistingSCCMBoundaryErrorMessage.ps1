###################################################################################################################
##### 115 character width indicator #####
###################################################################################################################

<#
.Synopsis
   Gets an error message containing existing SCCM boundaries.

.DESCRIPTION
   Gets an error message containing existing SCCM boundaries. The message contains a list of existing boundaries
including name, boundary type and boundary value, seperated by commas in the following format:
NAME/VALUE TYPE: VALUE

.EXAMPLE
    Get-ExistingSCCMBoundaryErrorMessage

    Test - Boundary - 1/IPSubnet: 100.100.100.0, Test - Boundary - 2/IPRange: 100.100.100.1-100.100.100.25, Test -
        Boundary - 3/ADSite: EUCDEV, Test IPv6 Boundary/IPV6Prefix: 0001:0000:0000:0003, Test - Boundary - 1/IPSubnet:
         234.63.12.0, Test - Boundary - 1/IPSubnet: 1.6.3.0, Test - Boundary - 1/IPSubnet: 1.56.3.0.

.INPUTS
    None

.OUTPUTS
    System.String
#>

function Get-ExistingSCCMBoundaryErrorMessage {

    [cmdletbinding()]
    [OutputType([String])]

    #There are no require input parameters. param() is required to use [cmdletbinding()] features.
    param()

    #Return a list of existing boundaries in the error message.
    $existingBoundaries = Get-CMBoundary | Select-Object -Property DisplayName,BoundaryType,Value

    [string] $errorMessage = "The following are existing boundaries:"

    #Add each boundary with the following format seperated by a comma: Name/ValueType: Value
    foreach($boundary in $existingBoundaries){

        [string] $boundaryType = switch ($boundary.BoundaryType){
            '0' {"IPSubnet"}
            '1' {"ADSite"}
            '2' {"IPV6Prefix"}
            '3' {"IPRange"}
            default {"OtherType"}
        }

        $errorMessage += " $($boundary.DisplayName)/$boundaryType`: $($boundary.Value),"
    }

    #Remove the comma at the end of the message and then add a full stop.
    $errorMessage = $errorMessage.Remove($errorMessage.Length-1) + '.'

    #Output the error message
    $errorMessage

}
