###################################################################################################################
##### 115 character width indicator #####
###################################################################################################################
<<<<<<< HEAD
=======

<#
.Synopsis
   Pester test script for the function Check-SCCMBoundaryModify.

.DESCRIPTION
   Pester test script for the function Check-SCCMBoundaryModify. Includes an isolation test with the tag
   'Isolation' which includes mocked functions. Includes a test run against SCCM with no mocking with the tag
   'SCCM Test'.
#>

Describe "Isolation Tests" -Tag "Isolation" {
>>>>>>> fb3a8b4993cc3f9f9b07f9fa27896ffab87205ec

    #Create mock boundary objects. BoundaryTpye = 0 defines boundary as an IPSubnet.
    $global:testBoundaryObject1 = (Get-PSDrive -Name CAS).connection.createinstance("SMS_Boundary")
    $testBoundaryObject1.DisplayName= 'Check - Modify - Test - Boundary - 1'
    $testBoundaryObject1.BoundaryType = '0'
    $testBoundaryObject1.Value = '1.1.1.0'
    $testBoundaryObject1.BoundaryID = 1

    #BoundaryType = 3 defines boundary as an IPRange
    $global:testBoundaryObject2 = (Get-PSDrive -Name CAS).connection.createinstance("SMS_Boundary")
    $testBoundaryObject2.DisplayName = 'Check - Modify - Test - Boundary - 2'
    $testBoundaryObject2.BoundaryType = '3'
    $testBoundaryObject2.Value = '3.3.3.3-5.5.5.5'
    $testBoundaryObject2.BoundaryID = 2

    #Create mock boundary objects where the BoundaryType is incorrect. Type = 3 means ADSite
    $global:testBoundaryObject3 = (Get-PSDrive -Name CAS).connection.createinstance("SMS_Boundary")
    $testBoundaryObject3.DisplayName= 'Check - Modify - Test - Boundary - 3'
    $testBoundaryObject3.BoundaryType = '1'
    $testBoundaryObject3.Value = '1.1.1.0'
    $testBoundaryObject3.BoundaryID = 3

    $global:testBoundaryObject4 = (Get-PSDrive -Name CAS).connection.createinstance("SMS_Boundary")
    $testBoundaryObject4.DisplayName = 'Check - Modify - Test - Boundary - 4'
    $testBoundaryObject4.BoundaryType = '1'
    $testBoundaryObject4.Value = '3.3.3.3-5.5.5.5'
    $testBoundaryObject4.BoundaryID = 4

Describe "Isolation Tests" -Tag "Isolation" {


    #Mock Get-CMBoundary to return the mock boundary objects.

    Mock Get-CMBoundary {
        return @($testBoundaryObject1,$testBoundaryObject2,$testBoundaryObject3,$testBoundaryObject4)
    } -ModuleName 'SCCMBoundaryTools'

    Mock Get-CMBoundary {return $null} `
    -ParameterFilter{
        $BoundaryName -ne 'Check - Modify - Test - Boundary - 1' -and
        $BoundaryName -ne 'Check - Modify - Test - Boundary - 2' -and
        $BoundaryName -ne 'Check - Modify - Test - Boundary - 3' -and
<<<<<<< HEAD
        $BoundaryName -ne 'Check - Modify - Test - Boundary - 4' -and
        $BoundaryName -ne $null -and
        $BoundaryName -ne ''
    } -ModuleName 'SCCMBoundaryTools'

    Mock Get-CMBoundary {return $testBoundaryObject1} `
    -ParameterFilter{$BoundaryName -eq 'Check - Modify - Test - Boundary - 1'}`
    -ModuleName 'SCCMBoundaryTools'

    Mock Get-CMBoundary {return $testBoundaryObject2} `
    -ParameterFilter{$BoundaryName -eq 'Check - Modify - Test - Boundary - 2'}`
    -ModuleName 'SCCMBoundaryTools'

    Mock Get-CMBoundary {return $testBoundaryObject3} `
    -ParameterFilter{$BoundaryName -eq 'Check - Modify - Test - Boundary - 3'}`
    -ModuleName 'SCCMBoundaryTools'

    Mock Get-CMBoundary {return $testBoundaryObject4} `
    -ParameterFilter{$kBoundaryName -eq 'Check - Modify - Test - Boundary - 4'}`
    -ModuleName 'SCCMBoundaryTools'
=======
        $BoundaryName -ne 'Check - Modify - Test - Boundary - 4'
    } -ModuleName 'SCCMBoundaryTools'

    Mock Get-CMBoundary {return $testBoundaryObject1} `
    -ParameterFilter{$BoundaryName -eq 'Check - Modify - Test - Boundary - 1'} -ModuleName 'SCCMBoundaryTools'

    Mock Get-CMBoundary {return $testBoundaryObject2} `
    -ParameterFilter{$BoundaryName -eq 'Check - Modify - Test - Boundary - 2'} -ModuleName 'SCCMBoundaryTools'

    Mock Get-CMBoundary {return $testBoundaryObject3} `
    -ParameterFilter{$BoundaryName -eq 'Check - Modify - Test - Boundary - 3'} -ModuleName 'SCCMBoundaryTools'

    Mock Get-CMBoundary {return $testBoundaryObject4} `
    -ParameterFilter{$BoundaryName -eq 'Check - Modify - Test - Boundary - 4'} -ModuleName 'SCCMBoundaryTools'
>>>>>>> 79b1ed9bc50089e3c15588715234f0d51c1579b7

    #Mock Get-WmiObject should return $null when none of the bellow conditions are met
    Mock Get-WmiObject {return $null} -ModuleName 'SCCMBoundaryTools'

    #Mock Get-WmiObject to return mock boundary objects when querying for existing boundary objects
<<<<<<< HEAD
    Mock Get-WmiObject {return $testBoundaryObject1} `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Check - Modify - Test - Boundary - 1'*"}`
    -ModuleName 'SCCMBoundaryTools'

    Mock Get-WmiObject {return $testBoundaryObject2} `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Check - Modify - Test - Boundary - 2'*"}`
    -ModuleName 'SCCMBoundaryTools'

    Mock Get-WmiObject {return $testBoundaryObject3} `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Check - Modify - Test - Boundary - 3'*"}`
    -ModuleName 'SCCMBoundaryTools'

    Mock Get-WmiObject {return $testBoundaryObject4} `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Check - Modify - Test - Boundary - 4'*"}`
    -ModuleName 'SCCMBoundaryTools'
=======
    Mock Get-WmiObject {return $testBoundaryObject1} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Check - Modify - Test - Boundary - 1'*"}

    Mock Get-WmiObject {return $testBoundaryObject2} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Check - Modify - Test - Boundary - 2'*"}

    Mock Get-WmiObject {return $testBoundaryObject3} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Check - Modify - Test - Boundary - 3'*"}

    Mock Get-WmiObject {return $testBoundaryObject4} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Check - Modify - Test - Boundary - 4'*"}
>>>>>>> 79b1ed9bc50089e3c15588715234f0d51c1579b7

    <#
    Mock Get-WmiObject to return $true when querying for a boundary group member and that boundary is
    one of the mock boundaries and the boundary group is the mock boundary group.
    #>

    #Get-CimInstance has the same inputs and outputs as Get-WmiObject
    Mock Get-CimInstance {return $null} -ModuleName 'SCCMBoundaryTools'

<<<<<<< HEAD
    Mock Get-CimInstance {return $testBoundaryObject1} `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Check - Modify - Test - Boundary - 1'*"}`
    -ModuleName 'SCCMBoundaryTools'

    Mock Get-CimInstance {return $testBoundaryObject2} `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Check - Modify - Test - Boundary - 2'*"}`
    -ModuleName 'SCCMBoundaryTools'

    Mock Get-CimInstance {return $testBoundaryObject3} `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Check - Modify - Test - Boundary - 3'*"}`
    -ModuleName 'SCCMBoundaryTools'

    Mock Get-CimInstance {return $testBoundaryObject4} `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Check - Modify - Test - Boundary - 4'*"}`
    -ModuleName 'SCCMBoundaryTools'

    Mock Get-CimInstance {return @{GroupID = 1}}  `
    -ParameterFilter{$Query -like  "*SMS_BoundaryGroup where Name = 'Test Group'*"} -ModuleName 'SCCMBoundaryTools'
=======
    Mock Get-CimInstance {return $testBoundaryObject1} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Check - Modify - Test - Boundary - 1'*"}

    Mock Get-CimInstance {return $testBoundaryObject2} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Check - Modify - Test - Boundary - 2'*"}

    Mock Get-CimInstance {return $testBoundaryObject3} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Check - Modify - Test - Boundary - 3'*"}

    Mock Get-CimInstance {return $testBoundaryObject4} -ModuleName 'SCCMBoundaryTools' `
    -ParameterFilter{$Query -like  "*SMS_Boundary where DisplayName = 'Check - Modify - Test - Boundary - 4'*"}

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

    Context "Boundary has been modified correctly." {

        #Boundary modified using an IPSubnet
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundaryObject1.DisplayName
            CheckBoundaryValue = $testBoundaryObject1.Value
            CheckBoundaryType = $testBoundaryObject1.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundaryObject1.DisplayName)' was modified correctly using IPsubnet." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeTrue
        }

        #Boundary modified using an IPRange
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundaryObject2.DisplayName
            CheckBoundaryValue = $testBoundaryObject2.Value
            CheckBoundaryType = $testBoundaryObject2.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundaryObject2.DisplayName)' was modified correctly using IPRange." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeTrue
        }
    }

    Context "IPSubnet boundary not modified correctly." {

        <#
        modified boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Check - Modify - Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            CheckBoundaryName = 'Incorrect Name'
            CheckBoundaryValue = $testBoundaryObject1.Value
            CheckBoundaryType = $testBoundaryObject1.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.CheckBoundaryName)' " +
            "was modified with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to modify boundary with '10.10.3.0/24' but it was modified with '1.1.1.0/24'
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundaryObject1.DisplayName
            CheckBoundaryValue = '10.10.3.0'
            CheckBoundaryType = $testBoundaryObject1.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject1.DisplayName) was modified with the incorrect value." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Test when a modified boundary is given the incorrect boundary code
        #Wanted to modify to a boundary defined by an IPSubnet but the boundary was given code for an ADSite

        $functionInputSplat = @{
            CheckBoundaryName = $testBoundaryObject3.DisplayName
            CheckBoundaryValue = $testBoundaryObject3.Value
            CheckBoundaryType = $testBoundaryObject3.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject3.DisplayName) was given the incorrect boundary type." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }
    }

    Context "IPRange boundary not modified correctly." {

        <#
        modified boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Check - Modify - Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            CheckBoundaryName = "Incorrect - Name"
            CheckBoundaryValue = $testBoundaryObject2.Value
            CheckBoundaryType = $testBoundaryObject2.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.CheckBoundaryName)' " +
            "was modified with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to modify boundary with range '0.0.0.0-1.1.1.1' but was modified with '3.3.3.3-5.5.5.5' instead
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundaryObject2.DisplayName
            CheckBoundaryValue = '0.0.0.0-1.1.1.1'
            CheckBoundaryType = $testBoundaryObject2.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject2.DisplayName) was modified with the incorrect end value." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Test when a modified boundary is given the incorrect boundary code
        #Wanted to modify to a boundary defined by an IPRange but the boundary was given code for an ADSite
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundaryObject4.DisplayName
            CheckBoundaryValue = $testBoundaryObject4.Value
            CheckBoundaryType = $testBoundaryObject4.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject4.DisplayName) was given the incorrect boundary type." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }
    }

    #Run tests to ensure that validation still occurs when WMI queries return an error.

    Context "Boundary has been modified correctly, WMI query returns an error." {

        #Mock Get-WmiObject to return an error
<<<<<<< HEAD
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} `
        -ParameterFilter {$Query} -ModuleName 'SCCMBoundaryTools'
=======
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} -ModuleName 'SCCMBoundaryTools' `
        -ParameterFilter {$Query}
>>>>>>> 79b1ed9bc50089e3c15588715234f0d51c1579b7

        #Boundary modified using an IPSubnet
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundaryObject1.DisplayName
            CheckBoundaryValue = $testBoundaryObject1.Value
            CheckBoundaryType = $testBoundaryObject1.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundaryObject1.DisplayName)' was modified correctly using IPsubnet." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeTrue
        }

        #Boundary modified using an IPRange
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundaryObject2.DisplayName
            CheckBoundaryValue = $testBoundaryObject2.Value
            CheckBoundaryType = $testBoundaryObject2.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundaryObject2.DisplayName)' was modified correctly using IPRange." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeTrue
        }
    }

    Context "IPSubnet boundary not modified correctly, WMI query returns an error." {

        #Mock Get-WmiObject to return an error
<<<<<<< HEAD
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} `
        -ParameterFilter {$Query} -ModuleName 'SCCMBoundaryTools'
=======
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} -ModuleName 'SCCMBoundaryTools' `
        -ParameterFilter {$Query}
>>>>>>> 79b1ed9bc50089e3c15588715234f0d51c1579b7

                <#
        modified boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Check - Modify - Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            CheckBoundaryName = 'Incorrect Name'
            CheckBoundaryValue = $testBoundaryObject1.Value
            CheckBoundaryType = $testBoundaryObject1.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.CheckBoundaryName)' " +
            "was modified with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to modify boundary with '10.10.3.0/24' but it was modified with '1.1.1.0/24'
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundaryObject1.DisplayName
            CheckBoundaryValue = '10.10.3.0'
            CheckBoundaryType = $testBoundaryObject1.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject1.DisplayName) was modified with the incorrect value." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Test when a modified boundary is given the incorrect boundary code
        #Wanted to modify to a boundary defined by an IPSubnet but the boundary was given code for an ADSite

        $functionInputSplat = @{
            CheckBoundaryName = $testBoundaryObject3.DisplayName
            CheckBoundaryValue = $testBoundaryObject3.Value
            CheckBoundaryType = $testBoundaryObject3.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject3.DisplayName) was given the incorrect boundary type." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }
    }

    Context "IPRange boundary not modified correctly, WMI query returns an error." {

        #Mock Get-WmiObject to return an error
<<<<<<< HEAD
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} `
        -ParameterFilter {$Query} -ModuleName 'SCCMBoundaryTools'

=======
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} -ModuleName 'SCCMBoundaryTools' `
        -ParameterFilter {$Query}

>>>>>>> 79b1ed9bc50089e3c15588715234f0d51c1579b7
        <#
        modified boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Check - Modify - Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            CheckBoundaryName = "Incorrect - Name"
            CheckBoundaryValue = $testBoundaryObject2.Value
            CheckBoundaryType = $testBoundaryObject2.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.CheckBoundaryName)' " +
            "was modified with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to modify boundary with range '0.0.0.0-1.1.1.1' but was modified with '3.3.3.3-5.5.5.5' instead
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundaryObject2.DisplayName
            CheckBoundaryValue = '0.0.0.0-1.1.1.1'
            CheckBoundaryType = $testBoundaryObject2.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject2.DisplayName) was modified with the incorrect end value." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Test when a modified boundary is given the incorrect boundary code
        #Wanted to modify to a boundary defined by an IPRange but the boundary was given code for an ADSite
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundaryObject4.DisplayName
            CheckBoundaryValue = $testBoundaryObject4.Value
            CheckBoundaryType = $testBoundaryObject4.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject4.DisplayName) was given the incorrect boundary type." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }
    }

    #Run tests to ensure that validation still occurs when WMI and CIM queries return an error.

    Context "Boundary has been modified correctly, WMI and CIM query returns an error." {

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

        #Boundary modified using an IPSubnet
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundaryObject1.DisplayName
            CheckBoundaryValue = $testBoundaryObject1.Value
            CheckBoundaryType = $testBoundaryObject1.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject1.DisplayName) was modified correctly using IPsubnet." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeTrue
        }

        #Boundary modified using an IPRange
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundaryObject2.DisplayName
            CheckBoundaryValue = $testBoundaryObject2.Value
            CheckBoundaryType = $testBoundaryObject2.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundaryObject2.DisplayName)' was modified correctly using IPRange." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeTrue
        }
    }

    Context "IPSubnet boundary not modified correctly, WMI and CIM  query returns an error." {

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
        modified boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Check - Modify - Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            CheckBoundaryName = 'Incorrect Name'
            CheckBoundaryValue = $testBoundaryObject1.Value
            CheckBoundaryType = $testBoundaryObject1.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.CheckBoundaryName)' " +
            "was modified with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to modify boundary with '10.10.3.0/24' but it was modified with '1.1.1.0/24'
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundaryObject1.DisplayName
            CheckBoundaryValue = '10.10.3.0'
            CheckBoundaryType = $testBoundaryObject1.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject1.DisplayName) was modified with the incorrect value." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Test when a modified boundary is given the incorrect boundary code
        #Wanted to modify to a boundary defined by an IPSubnet but the boundary was given code for an ADSite

        $functionInputSplat = @{
            CheckBoundaryName = $testBoundaryObject3.DisplayName
            CheckBoundaryValue = $testBoundaryObject3.Value
            CheckBoundaryType = $testBoundaryObject3.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject3.DisplayName) was given the incorrect boundary type." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }
    }

    Context "IPRange boundary not modified correctly, WMI and CIM query returns an error." {

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
        modified boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Check - Modify - Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            CheckBoundaryName = "Incorrect - Name"
            CheckBoundaryValue = $testBoundaryObject2.Value
            CheckBoundaryType = $testBoundaryObject2.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.CheckBoundaryName)' " +
            "was modified with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to modify boundary with range '0.0.0.0-1.1.1.1' but was modified with '3.3.3.3-5.5.5.5' instead
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundaryObject2.DisplayName
            CheckBoundaryValue = '0.0.0.0-1.1.1.1'
            CheckBoundaryType = $testBoundaryObject2.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject2.DisplayName) was modified with the incorrect end value." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Test when a modified boundary is given the incorrect boundary code
        #Wanted to modify to a boundary defined by an IPRange but the boundary was given code for an ADSite
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundaryObject4.DisplayName
            CheckBoundaryValue = $testBoundaryObject4.Value
            CheckBoundaryType = $testBoundaryObject4.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundaryObject4.DisplayName) was given the incorrect boundary type." {
            Check-SCCMBoundaryModify @functionInputSplat |
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

        #Boundary to check has been modified correctly but all queries fail.
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundaryObject1.DisplayName
            CheckBoundaryValue = $testBoundaryObject1.Value
            CheckBoundaryType = $testBoundaryObject1.BoundaryType
            SccmServer = 'EUCDEVSCCM01'
        }

        $shouldSplat = @{
            ExpectedMessage = "Could not confirm '$($testBoundaryObject1.DisplayName)' was modified."
            ExceptionType = 'NotImplementedException'
            Throw = $true
        }

        It "Should return the correct error." {
            {Check-SCCMBoundaryModify @functionInputSplat} |
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
    <#
    Define the boundary properties. With the following type definitions:
        IPSubnet - Type = 0
        ADSite - Type = 1
        IPRange - Type = 3
    #>

    $global:testBoundary1 = @{
        Name = 'Check - Modify - Test - Boundary - 1'
        Type = '0'
        Value = '1.1.1.0/24'
    }

    $global:testBoundary2 = @{
        Name = 'Check - Modify - Test - Boundary - 2'
        Type = '3'
        Value = '3.3.3.0-5.5.5.0'
    }

    #Use the 3rd and 4th test boundary to test incorrect boundary type assignment
    $global:testBoundary3 = @{
        Name = 'Check - Modify - Test - Boundary - 3'
        Type = '1'
        Value = '6.6.6.0/24'
    }

    $global:testBoundary4 = @{
        Name = 'Check - Modify - Test - Boundary - 4'
        Type = '1'
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

            #IPSubnets have BoundaryType = 0
            It "$($boundary.Type) boundary '$($boundary.Name)' has the correct type." {
                Get-CMBoundary -BoundaryName $boundary.Name |
                Select-Object -ExpandProperty BoundaryType |
                Should -Be $boundary.Type
            }

            #If the boundary is an IPSubnet boundary, then get the expected subnet ID from the CIDR address
            if($boundary.Type -eq '0'){

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

    Context "Boundary has been modified correctly." {

        #Boundary modified using an IPSubnet
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundary1.Name
            CheckBoundaryValue = Convert-CIDRToSubnetId -CIDRAddress $testBoundary1.Value
            CheckBoundaryType = $testBoundary1.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundary1.Name)' was modified correctly using IPsubnet." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeTrue
        }

        #Boundary modified using an IPRange
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundary2.Name
            CheckBoundaryValue = $testBoundary2.Value
            CheckBoundaryType = $testBoundary2.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundary2.Name)' was modified correctly using IPRange." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeTrue
        }
    }

    Context "IPSubnet boundary not modified correctly." {

        <#
        modified boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Check - Modify - Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            CheckBoundaryName = 'Incorrect Name'
            CheckBoundaryValue = Convert-CIDRToSubnetId -CIDRAddress $testBoundary1.Value
            CheckBoundaryType = $testBoundary1.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.CheckBoundaryName)' " +
            "was modified with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to modify boundary with '10.10.3.0/24' but it was modified with '1.1.1.0/24'
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundary1.Name
            CheckBoundaryValue = '10.10.3.0'
            CheckBoundaryType = $testBoundary1.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary1.Name) was modified with the incorrect value." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Test when a modified boundary is given the incorrect boundary code
        #Wanted to modify to a boundary defined by an IPSubnet but the boundary was given code for an ADSite

        $functionInputSplat = @{
            CheckBoundaryName = $testBoundary3.Name
            CheckBoundaryValue = $testBoundary3.Value
            CheckBoundaryType = $testBoundary3.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary3.Name) was given the incorrect boundary type." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }
    }

    Context "IPRange boundary not modified correctly." {

        <#
        modified boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Check - Modify - Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            CheckBoundaryName = "Incorrect - Name"
            CheckBoundaryValue = $testBoundary2.Value
            CheckBoundaryType = $testBoundary2.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.CheckBoundaryName)' " +
            "was modified with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to modify boundary with range '0.0.0.0-1.1.1.1' but was modified with '3.3.3.3-5.5.5.5' instead
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundary2.Name
            CheckBoundaryValue = '0.0.0.0-1.1.1.1'
            CheckBoundaryType = $testBoundary2.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary2.Name) was modified with the incorrect end value." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Test when a modified boundary is given the incorrect boundary code
        #Wanted to modify to a boundary defined by an IPRange but the boundary was given code for an ADSite
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundary4.Name
            CheckBoundaryValue = $testBoundary4.Value
            CheckBoundaryType = $testBoundary4.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary4.Name) was given the incorrect boundary type." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }
    }

    #Run tests to ensure that validation still occurs when WMI queries return an error.

    Context "Boundary has been modified correctly, WMI query returns an error." {

        #Mock Get-WmiObject to return an error
<<<<<<< HEAD
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} `
        -ParameterFilter {$Query} -ModuleName 'SCCMBoundaryTools'
=======
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} -ModuleName 'SCCMBoundaryTools' `
        -ParameterFilter {$Query}
>>>>>>> 79b1ed9bc50089e3c15588715234f0d51c1579b7

        #Boundary modified using an IPSubnet
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundary1.Name
            CheckBoundaryValue = Convert-CIDRToSubnetId -CIDRAddress $testBoundary1.Value
            CheckBoundaryType = $testBoundary1.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundary1.Name)' was modified correctly using IPsubnet." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeTrue
        }

        #Boundary modified using an IPRange
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundary2.Name
            CheckBoundaryValue = $testBoundary2.Value
            CheckBoundaryType = $testBoundary2.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundary2.Name)' was modified correctly using IPRange." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeTrue
        }
    }

    Context "IPSubnet boundary not modified correctly, WMI query returns an error." {

        #Mock Get-WmiObject to return an error
<<<<<<< HEAD
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} `
        -ParameterFilter {$Query} -ModuleName 'SCCMBoundaryTools'
=======
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} -ModuleName 'SCCMBoundaryTools' `
        -ParameterFilter {$Query}
>>>>>>> 79b1ed9bc50089e3c15588715234f0d51c1579b7

                <#
        modified boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Check - Modify - Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            CheckBoundaryName = 'Incorrect Name'
            CheckBoundaryValue = Convert-CIDRToSubnetId -CIDRAddress $testBoundary1.Value
            CheckBoundaryType = $testBoundary1.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.CheckBoundaryName)' " +
            "was modified with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to modify boundary with '10.10.3.0/24' but it was modified with '1.1.1.0/24'
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundary1.Name
            CheckBoundaryValue = '10.10.3.0'
            CheckBoundaryType = $testBoundary1.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary1.Name) was modified with the incorrect value." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Test when a modified boundary is given the incorrect boundary code
        #Wanted to modify to a boundary defined by an IPSubnet but the boundary was given code for an ADSite

        $functionInputSplat = @{
            CheckBoundaryName = $testBoundary3.Name
            CheckBoundaryValue = $testBoundary3.Value
            CheckBoundaryType = $testBoundary3.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary3.Name) was given the incorrect boundary type." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }
    }

    Context "IPRange boundary not modified correctly, WMI query returns an error." {

        #Mock Get-WmiObject to return an error
<<<<<<< HEAD
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} `
        -ParameterFilter {$Query} -ModuleName 'SCCMBoundaryTools'
=======
        Mock Get-WmiObject {throw "Get-WmiObject returns an error."} -ModuleName 'SCCMBoundaryTools' `
        -ParameterFilter {$Query}
>>>>>>> 79b1ed9bc50089e3c15588715234f0d51c1579b7

        <#
        modified boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Check - Modify - Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            CheckBoundaryName = "Incorrect - Name"
            CheckBoundaryValue = $testBoundary2.Value
            CheckBoundaryType = $testBoundary2.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.CheckBoundaryName)' " +
            "was modified with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to modify boundary with range '0.0.0.0-1.1.1.1' but was modified with '3.3.3.3-5.5.5.5' instead
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundary2.Name
            CheckBoundaryValue = '0.0.0.0-1.1.1.1'
            CheckBoundaryType = $testBoundary2.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary2.Name) was modified with the incorrect end value." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Test when a modified boundary is given the incorrect boundary code
        #Wanted to modify to a boundary defined by an IPRange but the boundary was given code for an ADSite
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundary4.Name
            CheckBoundaryValue = $testBoundary4.Value
            CheckBoundaryType = $testBoundary4.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary4.Name) was given the incorrect boundary type." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }
    }

    #Run tests to ensure that validation still occurs when WMI and CIM queries return an error.

    Context "Boundary has been modified correctly, WMI and CIM query returns an error." {

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

        #Boundary modified using an IPSubnet
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundary1.Name
            CheckBoundaryValue = Convert-CIDRToSubnetId -CIDRAddress $testBoundary1.Value
            CheckBoundaryType = $testBoundary1.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundary1.Name)' was modified correctly using IPsubnet." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeTrue
        }

        #Boundary modified using an IPRange
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundary2.Name
            CheckBoundaryValue = $testBoundary2.Value
            CheckBoundaryType = $testBoundary2.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary '$($testBoundary2.Name)' was modified correctly using IPRange." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeTrue
        }
    }

    Context "IPSubnet boundary not modified correctly, WMI and CIM  query returns an error." {

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
        modified boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Check - Modify - Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            CheckBoundaryName = 'Incorrect Name'
            CheckBoundaryValue = Convert-CIDRToSubnetId -CIDRAddress $testBoundary1.Value
            CheckBoundaryType = $testBoundary1.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.CheckBoundaryName)' " +
            "was modified with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to modify boundary with '10.10.3.0/24' but it was modified with '1.1.1.0/24'
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundary1.Name
            CheckBoundaryValue = '10.10.3.0'
            CheckBoundaryType = $testBoundary1.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary1.Name) was modified with the incorrect value." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Test when a modified boundary is given the incorrect boundary code
        #Wanted to modify to a boundary defined by an IPSubnet but the boundary was given code for an ADSite

        $functionInputSplat = @{
            CheckBoundaryName = $testBoundary3.Name
            CheckBoundaryValue = $testBoundary3.Value
            CheckBoundaryType = $testBoundary3.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary3.Name) was given the incorrect boundary type." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }
    }

    Context "IPRange boundary not modified correctly, WMI and CIM query returns an error." {

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
        modified boundary has incorrect name. Wanted boundary to be called 'Incorrect - Name' but the boundary was
        named 'Check - Modify - Test - Boundary - 1'.
        #>
        $functionInputSplat = @{
            CheckBoundaryName = "Incorrect - Name"
            CheckBoundaryValue = $testBoundary2.Value
            CheckBoundaryType = $testBoundary2.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        #Title is too long for code formating, place in a variable
        $itTitle = (
            "Confirmed boundary '$($functionInputSplat.CheckBoundaryName)' " +
            "was modified with incorrect name."
        )

        It $itTitle {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Wanted to modify boundary with range '0.0.0.0-1.1.1.1' but was modified with '3.3.3.3-5.5.5.5' instead
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundary2.Name
            CheckBoundaryValue = '0.0.0.0-1.1.1.1'
            CheckBoundaryType = $testBoundary2.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary2.Name) was modified with the incorrect end value." {
            Check-SCCMBoundaryModify @functionInputSplat |
            Should -BeFalse
        }

        #Test when a modified boundary is given the incorrect boundary code
        #Wanted to modify to a boundary defined by an IPRange but the boundary was given code for an ADSite
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundary4.Name
            CheckBoundaryValue = $testBoundary4.Value
            CheckBoundaryType = $testBoundary4.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        It "Confirmed boundary $($testBoundary4.Name) was given the incorrect boundary type." {
            Check-SCCMBoundaryModify @functionInputSplat |
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

        #Boundary to check has been modified correctly but all queries fail.
        $functionInputSplat = @{
            CheckBoundaryName = $testBoundary1.Name
            CheckBoundaryValue = Convert-CIDRToSubnetId -CIDRAddress $testBoundary1.Value
            CheckBoundaryType = $testBoundary1.Type
            SccmServer = 'EUCDEVSCCM01'
        }

        $shouldSplat = @{
            ExpectedMessage = "Could not confirm '$($testBoundary1.Name)' was modified."
            ExceptionType = 'NotImplementedException'
            Throw = $true
        }

        It "Should return the correct error." {
            {Check-SCCMBoundaryModify @functionInputSplat} |
            Should @shouldSplat
        }
    }
}

###################################################################################################################
##### 115 character width indicator #####
###################################################################################################################
