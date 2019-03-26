<#
.Synopsis
   Converts a CIDR address into an IP subnet ID.

.DESCRIPTION
   Converts a CIDR address representation of a subnet ID into a subnet ID in IP form.

.PARAMETER CIDRAddress
    CIDR address to be converted.

.EXAMPLE
   Convert-CIDRToSubnetId -CIDRAddress '10.98.34.0/24'

   10.98.34.0

.INPUTS
   System.String

.OUTPUTS
   System.String
#>

function Convert-CIDRToSubnetId {

    [cmdletbinding()]

    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateScript({Check-IPCIDR})]
        [string] $CIDRAddress
    )

    #Get the number of network bits to create subnet mask
    [int] $numNetworkBits = ($CIDRAddress -split('/'))[-1]

    #Initialise $networkMask to process
    [string[]] $networkMask = @('')*4

    #The first $numNetworkBits bits should be a 1, thest should be 0
    for($bit = 0; $bit -lt 32; $bit++){

        if($bit -lt $numNetworkBits){

            [string[]] $networkMask[[math]::Floor(($bit)/8)] += '1'

        }else{

            [string[]] $networkMask[[math]::Floor(($bit)/8)] += '0'

        }
    }

    #The above for loop produces spaces in each octet so replace the blank space with nothing.
    $networkMask = $networkMask -replace (' ',$null)

    #Convert each octet from a binary to a decimal number.
    for($octet = 0; $octet -lt 4; $octet++){

        [int] $sum = 0

        for($bit = 0; $bit -lt 8; $bit ++){

            if($networkMask[$octet][$bit] -eq '1'){

                $sum += [math]::Pow(2,7-$bit)

            }
        }
        $networkMask[$octet] = $sum.ToString()
    }

    <#
    Split the input into IP and and number of network bits. Then split the IP into individual occets to binary AND
    with the network mask.
    #>
    for($octet = 0; $octet -lt 4; $octet++){

        $networkMask[$octet] = [string] ([int] $networkMask[$octet] -band `
        [int] ((($CIDRAddress -split('/'))[0]) -split('\.'))[$octet])

    }

    #Join the octets into a single string to represent the subnet ID.
    return ([string] ($networkMask -join('.')))

}
