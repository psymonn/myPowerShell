###################################################################################################################
##### 115 character width indicator #####
###################################################################################################################

<#
.Synopsis
   Pester test script for the function Delete-SCCMBoundary.

.DESCRIPTION
   Pester test script for the function Delete-SCCMBoundary. Includes an isolation test with the tag 'Isolation'
   which includes mocked functions. Includes a test run against SCCM with no mocking with the tag 'SCCM Test'.
#>

#Test Delete-SCCMBoundary but isolate it's dependance on the ConfigurationManager module.

Describe "Isolation Tests." -Tag "Isolation"{


    #Mock boundary objects
    $global:test1BoundaryObject = New-Object -TypeName PSObject -Property @{
        DisplayName = 'Test - Boundary - 1';
        BoundaryType = '0';
        Value = '1.1.1.0'
    }

    $global:test2BoundaryObject = New-Object -TypeName PSObject -Property @{
        DisplayName = 'Test - Boundary - 2';
        BoundaryType = '0';
        Value = '97.64.5.128'
    }

    $global:test3BoundaryObject = New-Object -TypeName PSObject -Property @{
        DisplayName = 'Test - Boundary - 3';
        BoundaryType = '3';
        Value = '10.10.10.65-10.10.10.105'
    }

    #Define function mocks

    Mock Remove-CMBoundary {"Deleting: $Name"} -ModuleName 'SCCMBoundaryTools'

    Mock Get-ExistingSCCMBoundaryErrorMessage {
        (
            "The following are existing boundaries:" +
            " $($test1BoundaryObject.DisplayName)/IPSubnet: $($test1BoundaryObject.Value)," +
            " $($test2BoundaryObject.DisplayName)/IPSubnet: $($test2BoundaryObject.Value)," +
            " $($test3BoundaryObject.DisplayName)/IPRange: $($test3BoundaryObject.Value)."
        )
    } -ModuleName 'SCCMBoundaryTools'

    #Get-CMBoundary mocks
    Mock Get-CMBoundary {@($test1BoundaryObject,$test2BoundaryObject,$test3BoundaryObject)}`
    -ModuleName 'SCCMBoundaryTools'

    Mock Get-CMBoundary {$null} `
    -ParameterFilter{$BoundaryName -and $BoundaryName -ne $null} -ModuleName 'SCCMBoundaryTools'

    Mock Get-CMBoundary {$test1BoundaryObject} `
    -ParameterFilter{$BoundaryName -and $BoundaryName -eq 'Test - Boundary - 1'}`
    -ModuleName 'SCCMBoundaryTools'

    Mock Get-CMBoundary {$test2BoundaryObject} `
    -ParameterFilter{$BoundaryName -and $BoundaryName -eq 'Test - Boundary - 2'}`
    -ModuleName 'SCCMBoundaryTools'

    Mock Get-CMBoundary {$test3BoundaryObject} `
    -ParameterFilter{$BoundaryName -and $BoundaryName -eq 'Test - Boundary - 3'}`
    -ModuleName 'SCCMBoundaryTools'

    #Mock boundary delete check to return a result incidating the boundary has been deleted
    Mock Check-SCCMBoundaryDelete {$true}

    Context "Test deleting an existing boundary."{

        It "Should delete correct boundary."{
            Delete-SCCMBoundary -BoundaryName 'Test - Boundary - 1' |
            Should -Be 'Deleting: Test - Boundary - 1'
        }

    }

    Context "Boundary to delete doesn't exists."{

        $boundaryToDelete = 'Some Boundary'

        #Try to delet a function, if it terminates due to error then no boundary is deleted.
        try{
            $functionOutput = Delete-SCCMBoundary -BoundaryName $boundaryToDelete
        }catch{
            $functionOutput = $null
        }

        Write-Host "$functionOutput"

        It "Should not delete a boundary."{
            $functionOutput | Should -BeNullOrEmpty
        }

        $expectedError = "The following are existing boundaries:" +
            " $($test1BoundaryObject.DisplayName)/IPSubnet: $($test1BoundaryObject.Value)," +
            " $($test2BoundaryObject.DisplayName)/IPSubnet: $($test2BoundaryObject.Value)," +
            " $($test3BoundaryObject.DisplayName)/IPRange: $($test3BoundaryObject.Value)."

        $expectedException = 'System.ArgumentException'

        It "Should throw the correct correct error."{
            {Delete-SCCMBoundary -BoundaryName $boundaryToDelete}|
            Should -Throw -ExpectedMessage $expectedError -ExceptionType $expectedException
        }
    }

    Context "Boundary to delete is null."{

        #Try to delet a function, if it terminates due to error then no boundary is deleted.
        try{
            $functionOutput = Delete-SCCMBoundary -BoundaryName $null
        }catch{
            $functionOutput = $null
        }

        It "Should not delete a boundary."{
            $functionOutput |
            Should -BeNullOrEmpty
        }

        $expectedError = "Cannot validate argument on parameter `'BoundaryName`'"

        It "Should throw the correct correct error."{
            {Delete-SCCMBoundary -BoundaryName $boundaryToDelete}|
            Should -Throw -ExpectedMessage $expectedError
        }
    }

    Context "Boundary to delete is empty."{

        #Try to delet a function, if it terminates due to error then no boundary is deleted.
        try{
            $functionOutput = Delete-SCCMBoundary -BoundaryName ''
        }catch{
            $functionOutput = $null
        }

        It "Should not delete a boundary."{
            $functionOutput |
            Should -BeNullOrEmpty
        }

        $expectedError = "Cannot validate argument on parameter `'BoundaryName`'"

        It "Should throw the correct correct error."{
            {Delete-SCCMBoundary -BoundaryName ''}|
            Should -Throw -ExpectedMessage $expectedError
        }
    }

    Context "Boundary was not deleted correctly." {

        #Mock boundary delete check to return as result indicating the boundary has not been delete correctly.
        Mock Check-SCCMBoundaryDelete {$false} -ModuleName 'SCCMBoundaryTools'

        $expectedErrorMessage = "Boundary 'Test - Boundary - 1' was not deleted correctly."
        $expectedErrorException = 'System.NotImplementedException'

        It "Should throw the correct error" {
        {Delete-SCCMBoundary -BoundaryName 'Test - Boundary - 1'} |
        Should -Throw -ExpectedMessage $expectedErrorMessage -ExceptionType $expectedErrorException
        }

    }

    Context "Boundary deletion could not be verified." {

        #Mock boundary delete check to return error indicating verification failed.

        [string] $Global:errorMessage = (
            "Could not confirm 'Test - Boundary - 1' was deleted. " +
            "Please check that it was deleted."
        )

        Mock Check-SCCMBoundaryDelete {
            $PSCmdlet.ThrowTerminatingError(
                [System.Management.Automation.ErrorRecord]::new(
                    ([System.NotImplementedException] $errorMessage),
                    'DeleteValidateFailed',
                    [System.Management.Automation.ErrorCategory]::OpenError,
                    'Test - Boundary - 1'
                )
            )
        } -ModuleName 'SCCMBoundaryTools'

        $expectedErrorMessage = "Could not confirm 'Test - Boundary - 1' was deleted. Please check that it was deleted."
        $expectedErrorException = 'System.NotImplementedException'

        It "Should throw the correct error" {
        {Delete-SCCMBoundary -BoundaryName 'Test - Boundary - 1'} |
        Should -Throw -ExpectedMessage $expectedErrorMessage -ExceptionType $expectedErrorException
        }
    }
}

#Test Delete-SCCMBoundary but and it's dependance on the ConfigurationManager module.

Describe "Test with SCCM objects." -Tag "SCCM Test" {

    #Set the location as the SCCM PS Drive to be able to run commands against SCCM.
    Set-Location CAS:

    Context "Create a test boundary to delete to test function." {

        #Create a boundary to delete.

        New-CMBoundary -Name 'Test - Boundary - Delete' -Value '99.99.99.0/24' -Type IPSubnet

        It "Test boundary 'Test - Boundary - Delete' was created." {
            Get-CMBoundary -BoundaryName 'Test - Boundary - Delete' |
            Select-Object -ExpandProperty DisplayName |
            Should -Be 'Test - Boundary - Delete'
        }

        It "Test boundary created has correct value." {
            Get-CMBoundary -BoundaryName 'Test - Boundary - Delete' |
            Select-Object -ExpandProperty Value |
            Should -Be '99.99.99.0'
        }
    }

    Context "Test Delete-SCCMBoundary by deleting 'Test - Boundary - Delete' boundary." {

        Delete-SCCMBoundary -BoundaryName 'Test - Boundary - Delete'

        It "Deleted 'Test - Boundary - Delete' boundary." {
            Get-CMBoundary -BoundaryName 'Test - Boundary - Delete' |
            Should -BeNullOrEmpty
        }
    }
}

###################################################################################################################
##### 115 character width indicator #####
###################################################################################################################
