###################################################################################################################
##### 115 character width indicator #####
###################################################################################################################

<#
.Synopsis
   Pester test script for the function Convert-CIDRToSubnetId.

.DESCRIPTION
   Pester test script for the function Convert-CIDRToSubnetId.
#>

#Generate several random IP addresses and test the function for each possible number of network bits [0,32]

Describe "Test converting random CIDR address into subnet IDs." {

    #Number of tests to run for each number of network bits
    [int] $numberOfTests = 10

    Context "0 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/0"

            #Generate the expected output
            [string] $expectedOutput = '0.0.0.0'

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "1 network bit." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/1"

            #Generate the expected output

            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0] -band 128).0.0.0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "2 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/2"

            #Generate the expected output

            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0] -band 192).0.0.0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "3 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/3"

            #Generate the expected output

            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0] -band 224).0.0.0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "4 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/4"

            #Generate the expected output

            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0] -band 240).0.0.0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "5 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/5"

            #Generate the expected output

            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0] -band 248).0.0.0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "6 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/6"

            #Generate the expected output

            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0] -band 252).0.0.0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "6 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/6"

            #Generate the expected output

            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0] -band 252).0.0.0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "7 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/7"

            #Generate the expected output

            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0] -band 254).0.0.0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "8 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/8"

            #Generate the expected output

            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0] -band 255).0.0.0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "9 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/9"

            #Generate the expected output

            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1] -band 128).0.0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "10 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/10"

            #Generate the expected output

            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1] -band 192).0.0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "11 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/11"

            #Generate the expected output

            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1] -band 224).0.0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "12 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/12"

            #Generate the expected output

            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1] -band 240).0.0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "13 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/13"

            #Generate the expected output

            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1] -band 248).0.0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "14 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/14"

            #Generate the expected output

            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1] -band 252).0.0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "15 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/15"

            #Generate the expected output

            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1] -band 254).0.0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "16 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/16"

            #Generate the expected output

            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1]).0.0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "17 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/17"

            #Generate the expected output
            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1]).$($splitIpAddress[2] -band 128).0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "18 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/18"

            #Generate the expected output
            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1]).$($splitIpAddress[2] -band 192).0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "19 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/19"

            #Generate the expected output
            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1]).$($splitIpAddress[2] -band 224).0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "20 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/20"

            #Generate the expected output
            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1]).$($splitIpAddress[2] -band 240).0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "21 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/21"

            #Generate the expected output
            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1]).$($splitIpAddress[2] -band 248).0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "22 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/22"

            #Generate the expected output
            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1]).$($splitIpAddress[2] -band 252).0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "23 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/23"

            #Generate the expected output
            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1]).$($splitIpAddress[2] -band 254).0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "24 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/24"

            #Generate the expected output
            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1]).$($splitIpAddress[2]).0"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "25 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/25"

            #Generate the expected output
            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1]).$($splitIpAddress[2]).$($splitIpAddress[3] -band 128)"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "26 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/26"

            #Generate the expected output
            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1]).$($splitIpAddress[2]).$($splitIpAddress[3] -band 192)"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "27 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/27"

            #Generate the expected output
            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1]).$($splitIpAddress[2]).$($splitIpAddress[3] -band 224)"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "28 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/28"

            #Generate the expected output
            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1]).$($splitIpAddress[2]).$($splitIpAddress[3] -band 240)"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "29 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/29"

            #Generate the expected output
            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1]).$($splitIpAddress[2]).$($splitIpAddress[3] -band 248)"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "29 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/29"

            #Generate the expected output
            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1]).$($splitIpAddress[2]).$($splitIpAddress[3] -band 248)"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "30 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/30"

            #Generate the expected output
            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1]).$($splitIpAddress[2]).$($splitIpAddress[3] -band 252)"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "31 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/31"

            #Generate the expected output
            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$($splitIpAddress[0]).$($splitIpAddress[1]).$($splitIpAddress[2]).$($splitIpAddress[3] -band 254)"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

    Context "32 network bits." {

        foreach($test in (1..$numberOfTests)){

            #Generate a random IP address
            [string] $ipAddress = ("$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)." +
                "$(Get-Random -Maximum 255 -Minimum 0)"
            )

            #Format IP address as a CIDR address with 0 network bits
            [string] $cidrAddress = "$ipAddress/32"

            #Generate the expected output
            [int[]] $splitIpAddress = $ipAddress -split('\.')

            [string] $expectedOutput = "$ipAddress"

            It "Converts $cidrAddress to $expectedOutput" {
                Convert-CIDRToSubnetId -CIDRAddress $cidrAddress |
                Should -Be $expectedOutput
            }
        }
    }

}
