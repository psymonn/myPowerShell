###################################################################################################################
##### 115 character width indicator #####
###################################################################################################################

<#
.Synopsis
   Pester test script for the function Check-SCCMBoundaryCreate.

.DESCRIPTION
   Pester test script for the function Check-SCCMBoundaryCreate. Includes an isolation test with the tag
   'Isolation' which includes mocked functions. Includes a test run against SCCM with no mocking with the tag
   'SCCM Test'.
#>

Describe "Isolation Tests" -Tag "Isolation" {

    #Create mock boundary objects. BoundaryTpye = 0 defines boundary as an IPSubnet.
    $global:testBoundaryObject1 = (Get-PSDrive -Name CAS).connection.createinstance("SMS_Boundary")
    $testBoundaryObject1.DisplayName= 'Test - Boundary - 1'
    $testBoundaryObject1.BoundaryType = '0'
    $testBoundaryObject1.Value = '1.1.1.0'
    $testBoundaryObject1.BoundaryID = 1

    #BoundaryType = 3 defines boundary as an IPRange
    $global:testBoundaryObject2 = (Get-PSDrive -Name CAS).connection.createinstance("SMS_Boundary")
    $testBoundaryObject2.DisplayName = 'Test - Boundary - 2'
    $testBoundaryObject2.BoundaryType = '3'
    $testBoundaryObject2.Value = '3.3.3.3-5.5.5.5'
    $testBoundaryObject2.BoundaryID = 2

    #Create mock boundary objects where the BoundaryType is incorrect for the given boundary Vale
    $global:testBoundaryObject3 = (Get-PSDrive -Name CAS).connection.createinstance("SMS_Boundary")
    $testBoundaryObject3.DisplayName= 'Test - Boundary - 3'
    $testBoundaryObject3.BoundaryType = '3'
    $testBoundaryObject3.Value = '1.1.1.0'
    $testBoundaryObject3.BoundaryID = 3

    $global:testBoundaryObject4 = (Get-PSDrive -Name CAS).connection.createinstance("SMS_Boundary")
    $testBoundaryObject4.DisplayName = 'Test - Boundary - 4'
    $testBoundaryObject4.BoundaryType = '1'
    $testBoundaryObject4.Value = '3.3.3.3-5.5.5.5'
    $testBoundaryObject4.BoundaryID = 4

    #Mock Get-CMBoundary to return the mock boundary objects.

    Mock Get-CMBoundary {
        return @($testBoundaryObject1,$testBoundaryObject2,$testBoundaryObject3,$testBoundaryObject4)
    } -ModuleName 'SCCMBoundaryTools'

    Mock Get-CMBoundary {return $null} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{(
            $BoundaryName -ne 'Test - Boundary - 1' -and
            $BoundaryName -ne 'Test - Boundary - 2' -and
            $BoundaryName -ne 'Test - Boundary - 3' -and
            $BoundaryName -ne 'Test - Boundary - 4') -or
        $BoundaryGroupName -ne 'Test Group'
    } -ModuleName 'SCCMBoundaryTools'

<<<<<<< HEAD
    Mock Get-CMBoundary {return $testBoundaryObject1} `
    -ParameterFilter{$BoundaryName -eq 'Test - Boundary - 1'} -ModuleName 'SCCMBoundaryTools'

    Mock Get-CMBoundary {return $testBoundaryObject2} `
    -ParameterFilter{$BoundaryName -eq 'Test - Boundary - 2'} -ModuleName 'SCCMBoundaryTools'

    Mock Get-CMBoundary {return $testBoundaryObject3} `
    -ParameterFilter{$BoundaryName -eq 'Test - Boundary - 3'} -ModuleName 'SCCMBoundaryTools'

    Mock Get-CMBoundary {return $testBoundaryObject4} `
    -ParameterFilter{$BoundaryName -eq 'Test - Boundary - 4'} -ModuleName 'SCCMBoundaryTools'

    Mock Get-CMBoundary {return @($testBoundaryObject1,$testBoundaryObject2)} `
    -ParameterFilter{$BoundaryGroupName -eq 'Test Group'} -ModuleName 'SCCMBoundaryTools'
=======
    Mock Get-CMBoundary {return $testBoundaryObject1} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$BoundaryName -eq 'Test - Boundary - 1'}

    Mock Get-CMBoundary {return $testBoundaryObject2} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$BoundaryName -eq 'Test - Boundary - 2'}

    Mock Get-CMBoundary {return $testBoundaryObject3} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$BoundaryName -eq 'Test - Boundary - 3'}

    Mock Get-CMBoundary {return $testBoundaryObject4} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$BoundaryName -eq 'Test - Boundary - 4'}

    Mock Get-CMBoundary {return @($testBoundaryObject1,$testBoundaryObject2)} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$BoundaryGroupName -eq 'Test Group'}
>>>>>>> 79b1ed9bc50089e3c15588715234f0d51c1579b7

    #Mock Get-WmiObject should return $null when none of the bellow conditions are met
    Mock Get-WmiObject {return $null} -ModuleName 'SCCMBoundaryTools'

    #Mock Get-WmiObject to return mock boundary objects when querying for existing boundary objects
<<<<<<< HEAD
    Mock Get-WmiObject {return $testBoundaryObject1} `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Test - Boundary - 1'*"} `
    -ModuleName 'SCCMBoundaryTools'

    Mock Get-WmiObject {return $testBoundaryObject2} `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Test - Boundary - 2'*"} `
    -ModuleName 'SCCMBoundaryTools'

    Mock Get-WmiObject {return $testBoundaryObject3} `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Test - Boundary - 3'*"} `
    -ModuleName 'SCCMBoundaryTools'

    Mock Get-WmiObject {return $testBoundaryObject4} `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Test - Boundary - 4'*"} `
    -ModuleName 'SCCMBoundaryTools'

    #Mock Get-WmiObject to return a mock boundary group object when querying fior group nemd 'Test Group'
    Mock Get-WmiObject {return @{GroupID = 1}} `
    -ParameterFilter{$Query -like  "*SMS_BoundaryGroup where Name = 'Test Group'*"} `
    -ModuleName 'SCCMBoundaryTools'
=======
    Mock Get-WmiObject {return $testBoundaryObject1} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Test - Boundary - 1'*"}

    Mock Get-WmiObject {return $testBoundaryObject2} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Test - Boundary - 2'*"}

    Mock Get-WmiObject {return $testBoundaryObject3} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Test - Boundary - 3'*"}

    Mock Get-WmiObject {return $testBoundaryObject4} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Test - Boundary - 4'*"}

    #Mock Get-WmiObject to return a mock boundary group object when querying fior group nemd 'Test Group'
    Mock Get-WmiObject {return @{GroupID = 1}} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$Query -like  "*SMS_BoundaryGroup where Name = 'Test Group'*"}
>>>>>>> 79b1ed9bc50089e3c15588715234f0d51c1579b7

    <#
    Mock Get-WmiObject to return $true when querying for a boundary group member and that boundary is
    one of the mock boundaries and the boundary group is the mock boundary group.
    #>

    Mock Get-WmiObject {return $true} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$Query -like  "*GroupID = '1'*" -and (
            $Query -like  "*BoundaryID = '1'*" -or
            $Query -like  "*BoundaryID = '2'*" -or
            $Query -like  "*BoundaryID = '3'*" -or
            $Query -like  "*BoundaryID = '4'*"
        )
    } -ModuleName 'SCCMBoundaryTools'

    #Get-CimInstance has the same inputs and outputs as Get-WmiObject
    Mock Get-CimInstance {return $null} -ModuleName 'SCCMBoundaryTools'

<<<<<<< HEAD
    Mock Get-CimInstance {return $testBoundaryObject1} `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Test - Boundary - 1'*"}`
    -ModuleName 'SCCMBoundaryTools'

    Mock Get-CimInstance {return $testBoundaryObject2} `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Test - Boundary - 2'*"}`
    -ModuleName 'SCCMBoundaryTools'

    Mock Get-CimInstance {return $testBoundaryObject3} `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Test - Boundary - 3'*"}`
    -ModuleName 'SCCMBoundaryTools'

    Mock Get-CimInstance {return $testBoundaryObject4} `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Test - Boundary - 4'*"}`
    -ModuleName 'SCCMBoundaryTools'

    Mock Get-CimInstance {return @{GroupID = 1}}  `
    -ParameterFilter{$Query -like  "*SMS_BoundaryGroup where Name = 'Test Group'*"}`
    -ModuleName 'SCCMBoundaryTools'
=======
    Mock Get-CimInstance {return $testBoundaryObject1} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Test - Boundary - 1'*"}

    Mock Get-CimInstance {return $testBoundaryObject2} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Test - Boundary - 2'*"}

    Mock Get-CimInstance {return $testBoundaryObject3} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Test - Boundary - 3'*"}

    Mock Get-CimInstance {return $testBoundaryObject4} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Test - Boundary - 4'*"}

    Mock Get-CimInstance {return @{GroupID = 1}} -ModuleName 'SCCMBoundaryTools'  `
    -ParameterFilter{$Query -like  "*SMS_BoundaryGroup where Name = 'Test Group'*"}
>>>>>>> 79b1ed9bc50089e3c15588715234f0d51c1579b7

    Mock Get-CimInstance {return $true} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$Query -like  "*GroupID = '1'*" -and (
            $Query -like  "*BoundaryID = '1'*" -or
            $Query -like  "*BoundaryID = '2'*" -or
            $Query -like  "*BoundaryID = '3'*" -or
            $Query -like  "*BoundaryID = '4'*"
        )
    } -ModuleName 'SCCMBoundaryTools'

    Context "Boundary has been created correctly." {

        #Boundary created using an IPSubnet
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "$($testBoundaryObject1.DisplayName)"
            BoundarySubnetIdCidr = "$($testBoundaryObject1.Value)/24"
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundaryObject1.DisplayName)' was created correctly using IPsubnet." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeTrue
        }

        #Boundary created using an IPRange
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "$($testBoundaryObject2.DisplayName)"
            BoundaryRangeStartIp = ($testBoundaryObject2.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundaryObject2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundaryObject2.DisplayName)' was created correctly using IPRange." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeTrue
        }
    }

    Context "IPSubnet boundary not created correctly." {

        <#
        Created boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "Incorrect - Name"
            BoundarySubnetIdCidr = "$($testBoundaryObject1.Value)/24"
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.BoundaryName)' " +
            "was created with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to add boundary to boundary group 'Incorrect Group' but it was added to 'Test Group' instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Incorrect Group'
            BoundaryName = $testBoundaryObject1.DisplayName
            BoundarySubnetIdCidr = "$($testBoundaryObject1.Value)/24"
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject1.DisplayName) was added to the incorrect group." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with value '10.10.3.120/25' but it was created with '1.1.1.0/24'
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundaryObject1.DisplayName
            BoundarySubnetIdCidr = "10.10.3.120/25"
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject1.DisplayName) was created with the incorrect value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to create a boundary defined by an IPSubnet but the boundary was given the incorrect type code

        #Change the boundary type of $testBoundaryObject1 to 3 which indicates an IPRange
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundaryObject3.DisplayName
            BoundarySubnetIdCidr = "$($testBoundaryObject3.Value)/24"
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject3.DisplayName) was given the incorrect boundary type." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

    }

    Context "IPRange boundary not created correctly." {

        <#
        Created boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "Incorrect - Name"
            BoundaryRangeStartIp = ($testBoundaryObject2.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundaryObject2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.BoundaryName)' " +
            "was created with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to add boundary to boundary group 'Incorrect Group' but it was added to 'Test Group' instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Incorrect Group'
            BoundaryName = $testBoundaryObject2.DisplayName
            BoundaryRangeStartIp = ($testBoundaryObject2.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundaryObject2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject2.DisplayName) was added to the incorrect group." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with starting IP 3.3.3.0 but was created with a start IP of 3.3.3.3 instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundaryObject2.DisplayName
            BoundaryRangeStartIp = '3.3.3.0'
            BoundaryRangeEndIp = ($testBoundaryObject2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject2.DisplayName) was created with the incorrect start value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with ending IP 5.5.5.0 but was created with a end IP of 5.5.5.5 instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundaryObject2.DisplayName
            BoundaryRangeStartIp = ($testBoundaryObject2.Value -split('-'))[0]
            BoundaryRangeEndIp = '5.5.5.0'
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject2.DisplayName) was created with the incorrect end value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with range '0.0.0.0-1.1.1.1' but was created with '3.3.3.3-5.5.5.5' instead
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundaryObject2.DisplayName
            BoundaryRangeStartIp = '0.0.0.0'
            BoundaryRangeEndIp = '1.1.1.1'
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject2.DisplayName) was created with the incorrect end value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to create a boundary defined by an IPRange but the boundary was given the incorrect type code

        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "$($testBoundaryObject4.DisplayName)"
            BoundaryRangeStartIp = ($testBoundaryObject4.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundaryObject4.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject4.DisplayName) was given the incorrect boundary type." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }
    }

    #Run tests to ensure that validation still occurs when WMI queries return an error.

    Context "Boundary has been created correctly, WMI query returns an error." {

        #Mock Get-WmiObject to return an error
<<<<<<< HEAD
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} `
        -ParameterFilter {$Query} -ModuleName 'SCCMBoundaryTools'
=======
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} -ModuleName 'SCCMBoundaryTools' `
        -ParameterFilter {$Query}
>>>>>>> 79b1ed9bc50089e3c15588715234f0d51c1579b7

        #Boundary created using an IPSubnet
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "$($testBoundaryObject1.DisplayName)"
            BoundarySubnetIdCidr = "$($testBoundaryObject1.Value)/24"
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundaryObject1.DisplayName)' was created correctly using IPsubnet." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeTrue
        }

        #Boundary created using an IPRange
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "$($testBoundaryObject2.DisplayName)"
            BoundaryRangeStartIp = ($testBoundaryObject2.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundaryObject2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundaryObject2.DisplayName)' was created correctly using IPRange." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeTrue
        }
    }

    Context "IPSubnet boundary not created correctly, WMI query returns an error." {

        #Mock Get-WmiObject to return an error
<<<<<<< HEAD
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} `
        -ParameterFilter {$Query} -ModuleName 'SCCMBoundaryTools'
=======
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} -ModuleName 'SCCMBoundaryTools' `
        -ParameterFilter {$Query}
>>>>>>> 79b1ed9bc50089e3c15588715234f0d51c1579b7

        <#
        Created boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "Incorrect - Name"
            BoundarySubnetIdCidr = "$($testBoundaryObject1.Value)/24"
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.BoundaryName)' " +
            "was created with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to add boundary to boundary group 'Incorrect Group' but it was added to 'Test Group' instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Incorrect Group'
            BoundaryName = $testBoundaryObject1.DisplayName
            BoundarySubnetIdCidr = "$($testBoundaryObject1.Value)/24"
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject1.DisplayName) was added to the incorrect group." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with value '10.10.3.120/25' but it was created with '1.1.1.0/24'
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundaryObject1.DisplayName
            BoundarySubnetIdCidr = "10.10.3.120/25"
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject1.DisplayName) was created with the incorrect value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to create a boundary defined by an IPSubnet but the boundary was given the incorrect type code

        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundaryObject3.DisplayName
            BoundarySubnetIdCidr = "$($testBoundaryObject3.Value)/24"
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject3.DisplayName) was given the incorrect boundary type." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }
    }

    Context "IPRange boundary not created correctly, WMI query returns an error." {

        #Mock Get-WmiObject to return an error
<<<<<<< HEAD
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} `
        -ParameterFilter {$Query} -ModuleName 'SCCMBoundaryTools'
=======
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} -ModuleName 'SCCMBoundaryTools' `
        -ParameterFilter {$Query}
>>>>>>> 79b1ed9bc50089e3c15588715234f0d51c1579b7

        <#
        Created boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "Incorrect - Name"
            BoundaryRangeStartIp = ($testBoundaryObject2.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundaryObject2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.BoundaryName)' " +
            "was created with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to add boundary to boundary group 'Incorrect Group' but it was added to 'Test Group' instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Incorrect Group'
            BoundaryName = $testBoundaryObject2.DisplayName
            BoundaryRangeStartIp = ($testBoundaryObject2.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundaryObject2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject2.DisplayName) was added to the incorrect group." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with starting IP 3.3.3.0 but was created with a start IP of 3.3.3.3 instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundaryObject2.DisplayName
            BoundaryRangeStartIp = '3.3.3.0'
            BoundaryRangeEndIp = ($testBoundaryObject2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject2.DisplayName) was created with the incorrect start value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with ending IP 5.5.5.0 but was created with a end IP of 5.5.5.5 instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundaryObject2.DisplayName
            BoundaryRangeStartIp = ($testBoundaryObject2.Value -split('-'))[0]
            BoundaryRangeEndIp = '5.5.5.0'
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject2.DisplayName) was created with the incorrect end value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with range '0.0.0.0-1.1.1.1' but was created with '3.3.3.3-5.5.5.5' instead
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundaryObject2.DisplayName
            BoundaryRangeStartIp = '0.0.0.0'
            BoundaryRangeEndIp = '1.1.1.1'
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject2.DisplayName) was created with the incorrect end value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to create a boundary defined by an IPRange but the boundary was given the incorrect type code

        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "$($testBoundaryObject4.DisplayName)"
            BoundaryRangeStartIp = ($testBoundaryObject4.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundaryObject4.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject4.DisplayName) was given the incorrect boundary type." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }
    }

    #Run tests to ensure that validation still occurs when WMI and CIM queries return an error.

    Context "Boundary has been created correctly, WMI and CIM query returns an error." {

        #Mock Get-WmiObject and Get-CimInstance to return an error
<<<<<<< HEAD
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} `
        -ParameterFilter {$Query} -ModuleName 'SCCMBoundaryTools'

        Mock Get-CimInstance {throw "Get-CimInstance returns an error."} `
        -ParameterFilter {$Query} -ModuleName 'SCCMBoundaryTools'
=======
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} -ModuleName 'SCCMBoundaryTools' `
        -ParameterFilter {$Query}

        Mock Get-CimInstance {throw "Get-CimInstance returns an error."} -ModuleName 'SCCMBoundaryTools' `
        -ParameterFilter {$Query}
>>>>>>> 79b1ed9bc50089e3c15588715234f0d51c1579b7

        #Boundary created using an IPSubnet
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "$($testBoundaryObject1.DisplayName)"
            BoundarySubnetIdCidr = "$($testBoundaryObject1.Value)/24"
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundaryObject1.DisplayName)' was created correctly using IPsubnet." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeTrue
        }

        #Boundary created using an IPRange
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "$($testBoundaryObject2.DisplayName)"
            BoundaryRangeStartIp = ($testBoundaryObject2.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundaryObject2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundaryObject2.DisplayName)' was created correctly using IPRange." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeTrue
        }
    }

    Context "IPSubnet boundary not created correctly, WMI and CIM  query returns an error." {

        #Mock Get-WmiObject and Get-CimInstance to return an error
<<<<<<< HEAD
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} `
        -ParameterFilter {$Query} -ModuleName 'SCCMBoundaryTools'

        Mock Get-CimInstance {throw "Get-CimInstance returns an error."} `
        -ParameterFilter {$Query} -ModuleName 'SCCMBoundaryTools'
=======
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} -ModuleName 'SCCMBoundaryTools' `
        -ParameterFilter {$Query}

        Mock Get-CimInstance {throw "Get-CimInstance returns an error."} -ModuleName 'SCCMBoundaryTools' `
        -ParameterFilter {$Query}
>>>>>>> 79b1ed9bc50089e3c15588715234f0d51c1579b7

        <#
        Created boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "Incorrect - Name"
            BoundarySubnetIdCidr = "$($testBoundaryObject1.Value)/24"
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.BoundaryName)' " +
            "was created with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to add boundary to boundary group 'Incorrect Group' but it was added to 'Test Group' instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Incorrect Group'
            BoundaryName = $testBoundaryObject1.DisplayName
            BoundarySubnetIdCidr = "$($testBoundaryObject1.Value)/24"
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject1.DisplayName) was added to the incorrect group." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with value '10.10.3.120/25' but it was created with '1.1.1.0/24'
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundaryObject1.DisplayName
            BoundarySubnetIdCidr = "10.10.3.120/25"
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject1.DisplayName) was created with the incorrect value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to create a boundary defined by an IPSubnet but the boundary was given the incorrect type code

        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundaryObject3.DisplayName
            BoundarySubnetIdCidr = "$($testBoundaryObject3.Value)/24"
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject3.DisplayName) was given the incorrect boundary type." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }
    }

    Context "IPRange boundary not created correctly, WMI and CIM query returns an error." {

        #Mock Get-WmiObject and Get-CimInstance to return an error
<<<<<<< HEAD
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} `
        -ParameterFilter {$Query} -ModuleName 'SCCMBoundaryTools'

        Mock Get-CimInstance {throw "Get-CimInstance returns an error."} `
        -ParameterFilter {$Query} -ModuleName 'SCCMBoundaryTools'
=======
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} -ModuleName 'SCCMBoundaryTools' `
        -ParameterFilter {$Query}

        Mock Get-CimInstance {throw "Get-CimInstance returns an error."} -ModuleName 'SCCMBoundaryTools' `
        -ParameterFilter {$Query}
>>>>>>> 79b1ed9bc50089e3c15588715234f0d51c1579b7

        <#
        Created boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "Incorrect - Name"
            BoundaryRangeStartIp = ($testBoundaryObject2.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundaryObject2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.BoundaryName)' " +
            "was created with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to add boundary to boundary group 'Incorrect Group' but it was added to 'Test Group' instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Incorrect Group'
            BoundaryName = $testBoundaryObject2.DisplayName
            BoundaryRangeStartIp = ($testBoundaryObject2.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundaryObject2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject2.DisplayName) was added to the incorrect group." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with starting IP 3.3.3.0 but was created with a start IP of 3.3.3.3 instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundaryObject2.DisplayName
            BoundaryRangeStartIp = '3.3.3.0'
            BoundaryRangeEndIp = ($testBoundaryObject2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject2.DisplayName) was created with the incorrect start value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with ending IP 5.5.5.0 but was created with a end IP of 5.5.5.5 instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundaryObject2.DisplayName
            BoundaryRangeStartIp = ($testBoundaryObject2.Value -split('-'))[0]
            BoundaryRangeEndIp = '5.5.5.0'
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject2.DisplayName) was created with the incorrect end value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with range '0.0.0.0-1.1.1.1' but was created with '3.3.3.3-5.5.5.5' instead
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundaryObject2.DisplayName
            BoundaryRangeStartIp = '0.0.0.0'
            BoundaryRangeEndIp = '1.1.1.1'
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject2.DisplayName) was created with the incorrect end value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to create a boundary defined by an IPRange but the boundary was given the incorrect type code

        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "$($testBoundaryObject4.DisplayName)"
            BoundaryRangeStartIp = ($testBoundaryObject4.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundaryObject4.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject4.DisplayName) was given the incorrect boundary type." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }
    }

    Context "Could not validate as WMI, CIM and SCCM cmdlet queries return an error." {

        #Mock Get-WmiObject and Get-CimInstance to return an error
<<<<<<< HEAD
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} `
        -ParameterFilter {$Query} -ModuleName 'SCCMBoundaryTools'

        Mock Get-CimInstance {throw "Get-CimInstance returns an error."} `
        -ParameterFilter {$Query} -ModuleName 'SCCMBoundaryTools'

        Mock Get-CMBoundary {throw "Get-CMBoundary returns an error."} `
        -ParameterFilter{$BoundaryName -or $BoundaryGroupName} -ModuleName 'SCCMBoundaryTools'
=======
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} -ModuleName 'SCCMBoundaryTools' `
        -ParameterFilter {$Query}

        Mock Get-CimInstance {throw "Get-CimInstance returns an error."} -ModuleName 'SCCMBoundaryTools' `
        -ParameterFilter {$Query}

        Mock Get-CMBoundary {throw "Get-CMBoundary returns an error."} -ModuleName 'SCCMBoundaryTools' `
        -ParameterFilter{$BoundaryName -or $BoundaryGroupName}
>>>>>>> 79b1ed9bc50089e3c15588715234f0d51c1579b7

        <#
        Created boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundaryObject1.DisplayName
            BoundarySubnetIdCidr = "$($testBoundaryObject1.Value)/24"
            SccmServer = 'EUCDEVSCCM01'
        }

        $shouldSplat = @{
            ExpectedMessage = "Could not confirm '$($testBoundaryObject1.DisplayName)' was created."
            ExceptionType = 'NotImplementedException'
            Throw = $true
        }

        It "Should return the correct error." {
            {Check-SCCMBoundaryCreate @functionInputSplat} |
            Should @shouldSplat
        }
    }
}

Describe "Test with real SCCM objects." -Tag "SCCM Test" {

    #Set location to the SCCM PSDrive to run SCCM cmdlets
    Set-Location -Path CAS:

    #Define the SCCM server to run WMI/CIM queries against
    $sccmServer = 'EUCDEVSCCM01'

    #Create test boundaries to test with.

    #Define the boundary properties.

    $global:testBoundary1 = @{
        Name = 'Test - Boundary - 1'
        Type = 'IPSubnet'
        Value = '1.1.1.0/24'
    }

    $global:testBoundary2 = @{
        Name = 'Test - Boundary - 2'
        Type = 'IPRange'
        Value = '3.3.3.0-5.5.5.0'
    }

    #Use the 3rd and 4th test boundary to test incorrect boundary type assignment
    $global:testBoundary3 = @{
        Name = 'Test - Boundary - 3'
        Type = 'ADSite'
        Value = '6.6.6.0/24'
    }

    $global:testBoundary4 = @{
        Name = 'Test - Boundary - 4'
        Type = 'ADSite'
        Value = '30.30.30.0-50.50.50.0'
    }

    $boundariesToCreate = @(
        $testBoundary1
        $testBoundary2
        $testBoundary3
        $testBoundary4
    )

    $namesToCheck = @(
        $testBoundary1.Name
        $testBoundary2.Name
        $testBoundary3.Name
        $testBoundary4.Name
    )

    $valuesToCheck = @(
        Convert-CIDRToSubnetId -CIDRAddress $testBoundary1.Value
        $testBoundary2.Value
        $testBoundary3.Value
        $testBoundary4.Value
    )

    #Check to see if there are boundaries that need deleting
    $boundariesToDelete = Get-CMBoundary |
    Where-Object -FilterScript {
        ($_.Name -in $namesToCheck -or $_.value -in $valuesToCheck) -and
        ($_.Name -notlike "*EUC*")
    }

    #Delete any boundaries that need deleting
    foreach($boundary in $boundariesToDelete){

        Remove-CMBoundary -InputObject $boundary -Force

    }

    #Create all the boundaries required for testing
    foreach($boundary in $boundariesToCreate){

        New-CMBoundary @boundary

        #Move each boundary to the boundary group 'Test Group'
        Add-CMBoundaryToGroup -BoundaryName $boundary.Name -BoundaryGroupName 'Test Group'
    }

    #Confirm both test boundaries have the correct name, type and value before testing the function.

    Context "Check boundaries have been created correctly in SCCM before performing tests." {

        #Validate each test boundary

        foreach($boundary in $boundariesToCreate){

            It "$($boundary.Type) boundary '$($boundary.Name)' has the correct name." {
                Get-CMBoundary -BoundaryName $boundary.Name |
                Select-Object -ExpandProperty DisplayName |
                Should -Be $boundary.Name
            }

            #IPSubnets have type 0, ADSites have type 1, IPRanges have type 3
            switch ($boundary.Type) {
                'IPSubnet' {$expectedType = '0'}
                'ADSite' {$expectedType = '1'}
                'IPRange' {$expectedType = '3'}
            }

            #IPSubnets have BoundaryType = 0
            It "$($boundary.Type) boundary '$($boundary.Name)' has the correct type." {
                Get-CMBoundary -BoundaryName $boundary.Name |
                Select-Object -ExpandProperty BoundaryType |
                Should -Be $expectedType
            }

            #If the boundary is an IPSubnet boundary, then get the expected subnet ID from the CIDR address
            if($boundary.Type -eq 'IPSubnet'){

                $expectedValue = Convert-CIDRToSubnetId -CIDRAddress $boundary.Value

            }else{

                $expectedValue = $boundary.Value

            }

            It "$($boundary.Type) boundary '$($boundary.Name)' has the correct value." {
                Get-CMBoundary -BoundaryName $boundary.Name |
                Select-Object -ExpandProperty Value |
                Should -Be $expectedValue
            }
        }
    }

    Context "Boundaries are created correctly." {

        #Function inputs for boundary created using an IPSubnet
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundary1.Name
            BoundarySubnetIdCidr = $testBoundary1.Value
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirms IPSubnet boundary '$($testBoundary1.Name)' was created correctly." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeTrue
        }

        #Function inputs for boundary created using an IPRange
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "$($testBoundary2.Name)"
            BoundaryRangeStartIp = ($testBoundary2.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundary2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirms IPSubnet boundary '$($testBoundary2.Name)' was created correctly." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeTrue
        }

}

    Context "IPSubnet boundary not created correctly." {

        <#
        Created boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "Incorrect - Name"
            BoundarySubnetIdCidr = $testBoundary1.Value
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.BoundaryName)' " +
            "was created with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to add boundary to boundary group 'Incorrect Group' but it was added to 'Test Group' instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Incorrect Group'
            BoundaryName = $testBoundary1.Name
            BoundarySubnetIdCidr = $testBoundary1.Value
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary1.Name) was added to the incorrect group." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with value '10.10.3.120/25' but it was created with '1.1.1.0/24'
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundary1.Name
            BoundarySubnetIdCidr = "10.10.3.120/25"
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary1.Name) was created with the incorrect value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to create a boundary defined by an IPSubnet but the boundary was given the incorrect type

        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundary3.Name
            BoundarySubnetIdCidr = $testBoundary3.Value
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary3.Name) was given the incorrect boundary type." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

    }

    Context "IPRange boundary not created correctly." {

        <#
        Created boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "Incorrect - Name"
            BoundaryRangeStartIp = ($testBoundary2.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundary2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.BoundaryName)' " +
            "was created with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to add boundary to boundary group 'Incorrect Group' but it was added to 'Test Group' instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Incorrect Group'
            BoundaryName = $testBoundary2.Name
            BoundaryRangeStartIp = ($testBoundary2.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundary2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary2.Name) was added to the incorrect group." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with starting IP 3.3.3.128 but was created with a start IP of 3.3.3.3 instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundary2.Name
            BoundaryRangeStartIp = '3.3.3.128'
            BoundaryRangeEndIp = ($testBoundary2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary2.Name) was created with the incorrect start value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with ending IP 5.5.5.128 but was created with a end IP of 5.5.5.0 instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundary2.Name
            BoundaryRangeStartIp = ($testBoundary2.Value -split('-'))[0]
            BoundaryRangeEndIp = '5.5.5.128'
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary2.Name) was created with the incorrect end value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with range '0.0.0.0-1.1.1.1' but was created with '3.3.3.3-5.5.5.5' instead
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundary2.Name
            BoundaryRangeStartIp = '0.0.0.0'
            BoundaryRangeEndIp = '1.1.1.1'
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary2.Name) was created with the incorrect end value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to create a boundary defined by an IPRange but the boundary was given the incorrect type code

        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "$($testBoundary4.Name)"
            BoundaryRangeStartIp = ($testBoundary4.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundary4.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary4.Name) was given the incorrect boundary type." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }
    }

    #Run tests to ensure that validation still occurs when WMI queries return an error.

    Context "Boundary has been created correctly, WMI query returns an error." {

        #Mock Get-WmiObject to return an error
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} -ModuleName 'SCCMBoundaryTools'

        #Boundary created using an IPSubnet
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "$($testBoundary1.Name)"
            BoundarySubnetIdCidr = $testBoundary1.Value
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundary1.Name)' was created correctly using IPsubnet." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeTrue
        }

        #Boundary created using an IPRange
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "$($testBoundary2.Name)"
            BoundaryRangeStartIp = ($testBoundary2.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundary2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundary2.Name)' was created correctly using IPRange." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeTrue
        }
    }

    Context "IPSubnet boundary not created correctly, WMI query returns an error." {

        #Mock Get-WmiObject to return an error
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} -ModuleName 'SCCMBoundaryTools'

        <#
        Created boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "Incorrect - Name"
            BoundarySubnetIdCidr = $testBoundary1.Value
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.BoundaryName)' " +
            "was created with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to add boundary to boundary group 'Incorrect Group' but it was added to 'Test Group' instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Incorrect Group'
            BoundaryName = $testBoundary1.Name
            BoundarySubnetIdCidr = $testBoundary1.Value
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary1.Name) was added to the incorrect group." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with value '10.10.3.120/25' but it was created with '1.1.1.0/24'
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundary1.Name
            BoundarySubnetIdCidr = "10.10.3.120/25"
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary1.Name) was created with the incorrect value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to create a boundary defined by an IPSubnet but the boundary was given the incorrect type code

        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundary3.Name
            BoundarySubnetIdCidr = $testBoundary3.Value
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary3.Name) was given the incorrect boundary type." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }
    }

    Context "IPRange boundary not created correctly, WMI query returns an error." {

        #Mock Get-WmiObject to return an error
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} -ModuleName 'SCCMBoundaryTools'

        <#
        Created boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "Incorrect - Name"
            BoundaryRangeStartIp = ($testBoundary2.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundary2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.BoundaryName)' " +
            "was created with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to add boundary to boundary group 'Incorrect Group' but it was added to 'Test Group' instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Incorrect Group'
            BoundaryName = $testBoundary2.Name
            BoundaryRangeStartIp = ($testBoundary2.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundary2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary2.Name) was added to the incorrect group." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with starting IP 3.3.3.128 but was created with a start IP of 3.3.3.3 instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundary2.Name
            BoundaryRangeStartIp = '3.3.3.128'
            BoundaryRangeEndIp = ($testBoundary2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary2.Name) was created with the incorrect start value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with ending IP 5.5.5.128 but was created with a end IP of 5.5.5.0 instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundary2.Name
            BoundaryRangeStartIp = ($testBoundary2.Value -split('-'))[0]
            BoundaryRangeEndIp = '5.5.5.128'
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary2.Name) was created with the incorrect end value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with range '0.0.0.0-1.1.1.1' but was created with '3.3.3.3-5.5.5.5' instead
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundary2.Name
            BoundaryRangeStartIp = '0.0.0.0'
            BoundaryRangeEndIp = '1.1.1.1'
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary2.Name) was created with the incorrect end value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to create a boundary defined by an IPRange but the boundary was given the incorrect type code

        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "$($testBoundary4.Name)"
            BoundaryRangeStartIp = ($testBoundary4.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundary4.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary4.Name) was given the incorrect boundary type." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }
    }

    #Run tests to ensure that validation still occurs when WMI and CIM queries return an error.

    Context "Boundary has been created correctly, WMI and CIM query returns an error." {

        #Mock Get-WmiObject and Get-CimInstance to return an error
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} -ModuleName 'SCCMBoundaryTools'

        Mock Get-CimInstance {throw "Get-CimInstance returns an error."} -ModuleName 'SCCMBoundaryTools'

        #Boundary created using an IPSubnet
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundary1.Name
            BoundarySubnetIdCidr = $testBoundary1.Value
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundary1.Name)' was created correctly using IPsubnet." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeTrue
        }

        #Boundary created using an IPRange
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundary2.Name
            BoundaryRangeStartIp = ($testBoundary2.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundary2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundary2.Name)' was created correctly using IPRange." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeTrue
        }
    }

    Context "IPSubnet boundary not created correctly, WMI and CIM  query returns an error." {

        #Mock Get-WmiObject and Get-CimInstance to return an error
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} -ModuleName 'SCCMBoundaryTools'

        Mock Get-CimInstance {throw "Get-CimInstance returns an error."} -ModuleName 'SCCMBoundaryTools'

        <#
        Created boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "Incorrect - Name"
            BoundarySubnetIdCidr = $testBoundary1.Value
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.BoundaryName)' " +
            "was created with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to add boundary to boundary group 'Incorrect Group' but it was added to 'Test Group' instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Incorrect Group'
            BoundaryName = $testBoundary1.Name
            BoundarySubnetIdCidr = $testBoundary1.Value
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary1.Name) was added to the incorrect group." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with value '10.10.3.120/25' but it was created with '1.1.1.0/24'
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundary1.Name
            BoundarySubnetIdCidr = "10.10.3.120/25"
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary1.Name) was created with the incorrect value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to create a boundary defined by an IPSubnet but the boundary was given the incorrect type code

        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundary3.Name
            BoundarySubnetIdCidr = "$($testBoundary3.Value)/24"
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary3.Name) was given the incorrect boundary type." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }
    }

    Context "IPRange boundary not created correctly, WMI and CIM query returns an error." {

        #Mock Get-WmiObject and Get-CimInstance to return an error
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} -ModuleName 'SCCMBoundaryTools'

        Mock Get-CimInstance {throw "Get-CimInstance returns an error."} -ModuleName 'SCCMBoundaryTools'

        <#
        Created boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "Incorrect - Name"
            BoundaryRangeStartIp = ($testBoundary2.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundary2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.BoundaryName)' " +
            "was created with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to add boundary to boundary group 'Incorrect Group' but it was added to 'Test Group' instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Incorrect Group'
            BoundaryName = $testBoundary2.Name
            BoundaryRangeStartIp = ($testBoundary2.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundary2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary2.Name) was added to the incorrect group." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with starting IP 3.3.3.128 but was created with a start IP of 3.3.3.3 instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundary2.Name
            BoundaryRangeStartIp = '3.3.3.128'
            BoundaryRangeEndIp = ($testBoundary2.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary2.Name) was created with the incorrect start value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with ending IP 5.5.5.128 but was created with a end IP of 5.5.5.0 instead.
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundary2.Name
            BoundaryRangeStartIp = ($testBoundary2.Value -split('-'))[0]
            BoundaryRangeEndIp = '5.5.5.128'
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary2.Name) was created with the incorrect end value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted create boundary with range '0.0.0.0-1.1.1.1' but was created with '3.3.3.3-5.5.5.5' instead
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundary2.Name
            BoundaryRangeStartIp = '0.0.0.0'
            BoundaryRangeEndIp = '1.1.1.1'
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary2.Name) was created with the incorrect end value." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to create a boundary defined by an IPRange but the boundary was given the incorrect type code

        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = "$($testBoundary4.Name)"
            BoundaryRangeStartIp = ($testBoundary4.Value -split('-'))[0]
            BoundaryRangeEndIp = ($testBoundary4.Value -split('-'))[1]
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary4.Name) was given the incorrect boundary type." {
            Check-SCCMBoundaryCreate @functionInputSplat |
            Should -BeFalse
        }
    }

    Context "Could not validate as WMI, CIM and SCCM cmdlet queries return an error." {

        #Mock Get-WmiObject and Get-CimInstance to return an error
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} -ModuleName 'SCCMBoundaryTools'

        Mock Get-CimInstance {throw "Get-CimInstance returns an error."} -ModuleName 'SCCMBoundaryTools'

        Mock Get-CMBoundary {throw "Get-CMBoundary returns an error."} -ModuleName 'SCCMBoundaryTools'

        <#
        Created boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            BoundaryGroupAddedTo = 'Test Group'
            BoundaryName = $testBoundary1.Name
            BoundarySubnetIdCidr = $testBoundary1.Value
            SccmServer = 'EUCDEVSCCM01'
        }

        $shouldSplat = @{
            ExpectedMessage = "Could not confirm '$($testBoundary1.Name)' was created."
            ExceptionType = 'NotImplementedException'
            Throw = $true
        }

        It "Should return the correct error." {
            {Check-SCCMBoundaryCreate @functionInputSplat} |
            Should @shouldSplat
        }
    }
}

###################################################################################################################
##### 115 character width indicator #####
###################################################################################################################
