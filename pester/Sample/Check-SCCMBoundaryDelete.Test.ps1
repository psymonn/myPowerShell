###################################################################################################################
##### 115 character width indicator #####
###################################################################################################################

<#
.Synopsis
   Pester test script for the function Check-SCCMBoundaryDelete.

.DESCRIPTION
   Pester test script for the function Check-SCCMBoundaryDelete. Includes an isolation test with the tag
   'Isolation' which includes mocked functions. Includes a test run against SCCM with no mocking with the tag
   'SCCM Test'.
#>

#Run isolation tests by mocking internal querying functions
Describe "Isolation Tests." -Tag "Isolation" {


    Context "Boundary has been correctly deleted." {

        #Context specific mocks

        #No object should be returned from queries as it has been deleted.
        Mock Get-WmiObject {} -ModuleName 'SCCMBoundaryTools'

        Mock Get-CimInstance {} -ModuleName 'SCCMBoundaryTools'

        Mock Get-CMBoundary {} -ModuleName 'SCCMBoundaryTools'


        It "Returns a true result." {
            Check-SCCMBoundaryDelete -BoundaryName 'Test' |
            Should -BeTrue
        }
    }

    Context "Boundary has not been correctly deleted." {

        #Context specific mocks

        #Object queries should be non-empty as the object has not been deleted properly
        Mock Get-WmiObject {$true} -ModuleName 'SCCMBoundaryTools'

        Mock Get-CimInstance {$true} -ModuleName 'SCCMBoundaryTools'

        Mock Get-CMBoundary {$true} -ModuleName 'SCCMBoundaryTools'

        It "Returns a true result." {
            Check-SCCMBoundaryDelete -BoundaryName 'Test' |
            Should -BeFalse
        }
    }

    Context "WMI queries return an error" {

        #Context specific mocks

        #No object should be returned from queries as it has been deleted.
        Mock Get-WmiObject {throw "Get-WmiObject failed."} -ModuleName 'SCCMBoundaryTools'

        Mock Get-CimInstance {} -ModuleName 'SCCMBoundaryTools'

        Mock Get-CMBoundary {} -ModuleName 'SCCMBoundaryTools'

        It "Returns a true result." {
            Check-SCCMBoundaryDelete -BoundaryName 'Test' |
            Should -BeTrue
        }
    }

    Context "WMI and CIM queries returns an error." {

        #Context specific mocks

        #No object should be returned from queries as it has been deleted.
        Mock Get-WmiObject {throw "Get-WmiObject failed."} -ModuleName 'SCCMBoundaryTools'
<<<<<<< HEAD

=======

>>>>>>> 79b1ed9bc50089e3c15588715234f0d51c1579b7
        Mock Get-CimInstance {throw "Get-CimInstance failed."} -ModuleName 'SCCMBoundaryTools'

        Mock Get-CMBoundary {} -ModuleName 'SCCMBoundaryTools'

        It "Returns a true result." {
            Check-SCCMBoundaryDelete -BoundaryName 'Test' |
            Should -BeTrue
        }
    }

    Context "WMI, CIM and SCCM cmdlet queries result in errors." {

        #Context specific mocks

        #No object should be returned from queries as it has been deleted.
        Mock Get-WmiObject {throw "Get-WmiObject failed."} -ModuleName 'SCCMBoundaryTools'

        Mock Get-CimInstance {throw "Get-CimInstance failed."} -ModuleName 'SCCMBoundaryTools'
<<<<<<< HEAD
=======

        Mock Get-CMBoundary {throw "Configuration Manager module failed."} -ModuleName 'SCCMBoundaryTools'
>>>>>>> 79b1ed9bc50089e3c15588715234f0d51c1579b7

        Mock Get-CMBoundary {throw "Configuration Manager module failed."} -ModuleName 'SCCMBoundaryTools'

        It "Returns the correct error." {
            {Check-SCCMBoundaryDelete -BoundaryName 'Test'} |
            Should -Throw -ExpectedMessage "Could not confirm 'Test' was deleted. Please check that it was deleted."
        }
    }
}

#Run tests agains WMI, CIM and SCCM

Describe "Test with real SCCM objects." -Tag "SCCM Test" {

    #Set location to the SCCM PSDrive to run SCCM cmdlets
    Set-Location -Path CAS:

    #Define the SCCM server to run WMI/CIM queries against
    $sccmServer = 'EUCDEVSCCM01'

    Context "Boundary has been successfully deleted." {

        $boundaryToCheck = 'Deleted Boundary'

        #Check if a the $boundaryToCheck exists, if it does remove it.
        if(Get-CMBoundary -BoundaryName $boundaryToCheck){

            Remove-CMBoundary -Name $boundaryToCheck -Force

        }

        It "Should return a true result." {
            Check-SCCMBoundaryDelete -BoundaryName $boundaryToCheck -SccmServer $sccmServer |
            Should -BeTrue
        }
    }

    Context "Boundary has not been deleted successfully." {

        $boundaryToCheck = 'Deleted Boundary'

        #If $boundaryToCheck doesn't exist then create it provide a boundary to test against.
        if((Get-CMBoundary -BoundaryName $boundaryToCheck) -eq $null){

            New-CMBoundary -Name $boundaryToCheck -Type IPSubnet -Value '20.20.20.0/24'

        }

        It "Should return a false result." {
            Check-SCCMBoundaryDelete -BoundaryName $boundaryToCheck -SccmServer $sccmServer |
            Should -BeFalse
        }

         Remove-CMBoundary -Name $boundaryToCheck -Force
    }

    Context "Boundary has been successfully deleted and WMI commands fail." {

        #Test that Get-CimInstance can validate boundary has been deleted

        #Mock Get-WmiObject to return an error as if it had failed.
        Mock Get-WmiObject {throw "Get-WmiObject failed."} -ModuleName 'SCCMBoundaryTools'

        $boundaryToCheck = 'Deleted Boundary'

        #Check if a the $boundaryToCheck exists, if it does remove it.
        if(Get-CMBoundary -BoundaryName $boundaryToCheck){

            Remove-CMBoundary -Name $boundaryToCheck -Force

        }

        It "Should return a true result." {
            Check-SCCMBoundaryDelete -BoundaryName $boundaryToCheck -SccmServer $sccmServer |
            Should -BeTrue
        }
    }

    Context "Boundary has been successfully deleted and WMI and CIM commands fail." {

        #Test that Get-CMBoundary can validate boundary has been deleted.

        #Mock Get-WmiObject and Get-CimInstance to return an error as if it had failed.
        Mock Get-WmiObject {throw "Get-WmiObject failed."} -ModuleName 'SCCMBoundaryTools'

        Mock Get-CimInstance {throw "Get-CimInstance failed."} -ModuleName 'SCCMBoundaryTools'

        $boundaryToCheck = 'Deleted Boundary'

        #Check if a the $boundaryToCheck exists, if it does remove it.
        if(Get-CMBoundary -BoundaryName $boundaryToCheck){

            Remove-CMBoundary -Name $boundaryToCheck -Force

        }

        It "Should return a true result." {
            Check-SCCMBoundaryDelete -BoundaryName $boundaryToCheck -SccmServer $sccmServer |
            Should -BeTrue
        }
    }
}
