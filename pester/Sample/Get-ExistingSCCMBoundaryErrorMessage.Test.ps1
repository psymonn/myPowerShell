###################################################################################################################
##### 115 character width indicator #####
###################################################################################################################

<#
.Synopsis
   Pester test script for the function Get-ExistingSCCMBoundaryErrorMessage.

.DESCRIPTION
   Pester test script for the function Get-ExistingSCCMBoundaryErrorMessage.
#>

Describe "Isolation Test" {

    Context "Existing object has an IPSubnet value" {


        #Context specific mock.
        $mockSplat = @{
            CommandName = 'Get-CMBoundary'
            MockWith = {
                New-Object -TypeName PSObject -Property @{
                    DisplayName = 'Test Boundary 1';BoundaryType = '0';Value = '12.45.3.7'
                }
            }
            ModuleName = 'SCCMBoundaryTools'
        }

        Mock @mockSplat


        $subnetMockBoundaryObject = "New-Object -TypeName PSObject -Property @{
            DisplayName = 'Test Boundary 1';BoundaryType = '0';Value = '12.45.3.7'
        }"

        #Context specific mock.
        Mock Get-CMBoundary {$subnetMockBoundaryObject} -ModuleName 'SCCMBoundaryTools'


        $referenceMessage = ("The following are existing boundaries:" +
        " Test Boundary 1/IPSubnet: 12.45.3.7."
        )

        It "Should return the correct message" {
            Get-ExistingSCCMBoundaryErrorMessage |
            Should -Be $referenceMessage
        }

    }

    Context "Existing object has an ADSite value." {

        #Context specific mock.
        $mockSplat = @{
            CommandName = 'Get-CMBoundary'
            MockWith = {
                New-Object -TypeName PSObject -Property @{
                    DisplayName = 'Test Boundary 2';BoundaryType = '1';Value = 'DOMAIN'
                }
            }
            ModuleName = 'SCCMBoundaryTools'
        }


        Mock @mockSplat

        #Context specific mock.
        Mock Get-CMBoundary {New-Object -TypeName PSObject -Property @{DisplayName = 'Test Boundary 2';BoundaryType = '1';Value = 'DOMAIN'}} -ModuleName 'SCCMBoundaryTools'


        $referenceMessage = ("The following are existing boundaries:" +
        " Test Boundary 2/ADSite: DOMAIN."
        )

        It "Should return the correct message" {
            Get-ExistingSCCMBoundaryErrorMessage |
            Should -Be $referenceMessage
        }

    }

    Context "Existing object has an IPv6Prefix value." {

        #Context specific mock.
        $mockSplat = @{
            CommandName = 'Get-CMBoundary'
            MockWith = {
            New-Object -TypeName PSObject -Property @{
                    DisplayName = 'Test Boundary 3';BoundaryType = '2';Value = '1111:1111:1111:1111'
                }
            }
            ModuleName = 'SCCMBoundaryTools'
        }


        Mock @mockSplat

        #Context specific mock.
        Mock Get-CMBoundary {$IPv6MockBoundaryObject} -ModuleName 'SCCMBoundaryTools'


        $referenceMessage = ("The following are existing boundaries:" +
        " Test Boundary 3/IPv6Prefix: 1111:1111:1111:1111."
        )

        It "Should return the correct message" {
            Get-ExistingSCCMBoundaryErrorMessage |
            Should -Be $referenceMessage
        }

    }

    Context "Existing object has an IPRange value." {

        #Context specific mock.
        $mockSplat = @{
            CommandName = 'Get-CMBoundary'
            MockWith = {
                New-Object -TypeName PSObject -Property @{
                    DisplayName = 'Test Boundary 4';BoundaryType = '3';Value = '1.1.1.1-1.1.1.9'
                }
            }
            ModuleName = 'SCCMBoundaryTools'
        }


        Mock @mockSplat

        #Context specific mock.
        Mock Get-CMBoundary {$rangetMockBoundaryObject} -ModuleName 'SCCMBoundaryTools'


        $referenceMessage = ("The following are existing boundaries:" +
        " Test Boundary 4/IPRange: 1.1.1.1-1.1.1.9."
        )

        It "Should return the correct message" {
            Get-ExistingSCCMBoundaryErrorMessage |
            Should -Be $referenceMessage
        }

    }

}
