###################################################################################################################
##### 115 character width indicator #####
###################################################################################################################

<#
.Synopsis
   Pester test script for the function Modify-SCCMBoundary.

.DESCRIPTION
   Pester test script for the function Modify-SCCMBoundary. Includes an isolation test with the tag 'Isolation'
   which includes mocked functions. Includes a test run against SCCM with no mocking with the tag 'SCCM Test'.
#>

Describe "Isolation Test" -Tag "Isolation" {

    <#
    Run isolation tests by mocking any cmdlets in the ConfgurationManager module. This means that the following
    tests in this describe block are not dependent on correctly working ConfgurationManager cmdlets. This makes
    means the results of this test will confirm if inputs to the function are correctly passed and processed
    through the function.
    #>

    #Define Mocks

    <#
    Mock Get-CMBoundaryGroup to output $null when 'Test Group' boundry group not selected as the
    BoundaryGroupToAddTo.
    #>

    $mockGetCMBoundaryGroupScriptBlock = {
        if($Name -eq 'Test Group'){
            return ($Name)
        }else{
            return ($null)
        }
    }

   # Mock Get-CMBoundaryGroup $mockGetCMBoundaryGroupScriptBlock -ModuleName 'SCCMBoundaryTools'

    <#
    Mock Get-CMBoundary to so that $null is returned if 'Test - Boundary 1', 'Test - Boundary 2', or 'Test -
    Boundary - 3' is not selected as the BoundarName.

    $userInput is the input to the
    #>

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

    $mockGetCMBoundaryScriptBlock = {
        switch ($BoundaryName){
            'Test - Boundary - 1' {$test1BoundaryObject}
            'Test - Boundary - 2' {$test2BoundaryObject}
            'Test - Boundary - 3' {$test3BoundaryObject}
            default {$null}
        }
    }

    #Mock boundary modify check to return a result incidating the boundary has been modified
    Mock Check-SCCMBoundaryCreate {$true} -ModuleName 'SCCMBoundaryTools'

    Mock Get-CMBoundary $mockGetCMBoundaryScriptBlock -ModuleName 'SCCMBoundaryTools'

    #Mock New-CMBoundary to output a hashtable with the name of the boundary and value of the boundary created.
    $mockNewCMBondaryScriptBlock = { @{DisplayName = $Name ; Value = $Value} }

    Mock New-CMBoundary $mockNewCMBondaryScriptBlock -ModuleName 'SCCMBoundaryTools'
    <#
    Mock Add-CMBoundaryToGroup to return the $groupToAddTo that contains the boundary group name of the boundary
    that was added to that group.
    #>

    Mock Add-CMBoundaryToGroup {} -ModuleName 'SCCMBoundaryTools'

    #Mock Get-ExistingSCCMBoundaryErrorMessage to return error message.

    Mock Get-ExistingSCCMBoundaryErrorMessage {
        (
            "The following are existing boundaries:" +
            " $($test1BoundaryObject.DisplayName)/IPSubnet: $($test1BoundaryObject.Value)," +
            " $($test2BoundaryObject.DisplayName)/IPSubnet: $($test2BoundaryObject.Value)," +
            " $($test3BoundaryObject.DisplayName)/IPRange: $($test3BoundaryObject.Value)."
        )
    } -ModuleName 'SCCMBoundaryTools'

    #Test correct boundary creation process using IP subnets.

    Context "Test boundary creation with IP subnets." {

        #Test that correct boundary will be created when using IP subnets.

        $ipSubnetInputs = @{
            BoundaryGroupToAddTo = 'Test Group'
            BoundaryName = 'Test - Boundary - 4'
            BoundarySubnetIdCidr = '100.100.100.128/25'
        }

        $functionOutput = Create-SCCMBoundary @ipSubnetInputs

        It "Should create a boundary with the correct name." {
            $functionOutput.DisplayName | Should -Be 'Test - Boundary - 4'
        }

        It "Should create a boundary with the correct value." {
            $functionOutput.Value | Should -Be "$($ipSubnetInputs.BoundarySubnetIdCidr)"
        }

    }

    #Test correct boundary creation creation process using an IP range.

    Context "Test boundary creation with an IP range." {

        $ipRangeInputs = @{
            BoundaryGroupToAddTo = 'Test Group'
            BoundaryName = 'Test - Boundary - 4'
            BoundaryRangeStartIp = '100.35.63.35'
            BoundaryRangeEndIp = '100.35.63.98'
        }

        $functionOutput = Create-SCCMBoundary @ipRangeInputs

        It "Should create a boundary with the correct name." {
            $functionOutput.DisplayName | Should -Be 'Test - Boundary - 4'
        }

        It "Should create a boundary with the correct value." {
            $functionOutput.Value | Should -Be "$($ipRangeInputs.BoundaryRangeStartIp)-$($ipRangeInputs.BoundaryRangeEndIp)"
        }

        <#
        If the end IP address is smaller than the start IP address then the the start IP and the end IP should be
        swapped around.
        #>

        $ipRangeInputs.BoundaryRangeStartIp = '100.35.64.23'
        $ipRangeInputs.BoundaryRangeEndIp = '100.35.64.2'
        $functionOutput = Create-SCCMBoundary @ipRangeInputs

        It "Should create a boundary with the correct value when END IP < START IP, 4th octect." {
            $functionOutput.Value | Should -Be "$($ipRangeInputs.BoundaryRangeEndIp)-$($ipRangeInputs.BoundaryRangeStartIp)"
        }

        $ipRangeInputs.BoundaryRangeStartIp = '100.35.64.23'
        $ipRangeInputs.BoundaryRangeEndIp = '100.35.59.214'
        $functionOutput = Create-SCCMBoundary @ipRangeInputs

        It "Should create a boundary with the correct value when END IP < START IP, 3rd octect." {
            $functionOutput.Value | Should -Be "$($ipRangeInputs.BoundaryRangeEndIp)-$($ipRangeInputs.BoundaryRangeStartIp)"
        }

        $ipRangeInputs.BoundaryRangeStartIp = '100.26.59.2'
        $ipRangeInputs.BoundaryRangeEndIp = '100.11.59.2'
        $functionOutput = Create-SCCMBoundary @ipRangeInputs

        It "Should create a boundary with the correct value when END IP < START IP, 2nd octect." {
            $functionOutput.Value | Should -Be "$($ipRangeInputs.BoundaryRangeEndIp)-$($ipRangeInputs.BoundaryRangeStartIp)"
        }

        $ipRangeInputs.BoundaryRangeStartIp = '100.26.59.2'
        $ipRangeInputs.BoundaryRangeEndIp = '99.203.59.2'
        $functionOutput = Create-SCCMBoundary @ipRangeInputs

        It "Should create a boundary with the correct value when END IP < START IP, 1st octect." {
            $functionOutput.Value | Should -Be "$($ipRangeInputs.BoundaryRangeEndIp)-$($ipRangeInputs.BoundaryRangeStartIp)"
        }

    }

    #Test that the correct errors are returned when creating boundaries using erroneous IP subnets.

    #Test correct errors are returned when the BoundaryGroupToAddTo parameter is erroneous

    # Context "IP Subnet errors - boundary group does not exist." {

    #     #Context specific mock.

    #     Mock Get-CMBoundaryGroup {New-Object -TypeName PSObject -Property @{Name = 'Test Group'}}`
    #     -ModuleName 'SCCMBoundaryTools'

    #     Mock Get-CMBoundaryGroup {'Test Group'} -ParameterFilter {$Name -and $Name -eq 'Test Group'}`
    #     -ModuleName 'SCCMBoundaryTools'

    #     Mock Get-CMBoundaryGroup {$null} -ParameterFilter {$Name -and $Name -ne 'Test Group' -and $Name -ne $null}`
    #     -ModuleName 'SCCMBoundaryTools'

    #     $erroneousIpSubnetInputs = @{
    #         BoundaryGroupToAddTo = "Some group that doesn't exist"
    #         BoundaryName = 'Test - Boundary - 4'
    #         BoundarySubnetIdCidr = '100.100.100.128/25'
    #     }

    #     #See if $functionOutput is occupied, if it is clear it.
    #     if($functionOutput){
    #         Remove-Variable -Name functionOutput
    #     }

    #     <#
    #     See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
    #     Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
    #     #>
    #     try{
    #         $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
    #     }catch{
    #     }

    #     It "Should not create a new boundary." {
    #         $functionOutput| Should -BeNullOrEmpty
    #     }

    #     $errorMessage = (
    #         "$($erroneousIpSubnetInputs.BoundaryGroupToAddTo) is not an existing SCCM boundary group." +
    #         " The following are existing groups:" +
    #         " Test Group."
    #     )


    #     It "Should throw correct error message and exception." {
    #         {Create-SCCMBoundary @erroneousIpSubnetInputs} |
    #         Should -Throw $errorMessage -ExceptionType 'System.ArgumentException'
    #     }
    # }

    Context "IP Subnet errors - boundary group is null." {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = $null
            BoundaryName = 'Test - Boundary - 4'
            BoundarySubnetIdCidr = '100.100.100.128/25'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} | Should -Throw
        }

        #Use a Try block to catch the error and check the error message.
        try{
            Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundaryGroupToAddTo`'*"
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }
    }

    Context "IP Subnet errors - boundary group is empty." {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = ''
            BoundaryName = 'Test - Boundary - 4'
            BoundarySubnetIdCidr = '100.100.100.128/25'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>

        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} | Should -Throw
        }

        #Use a Try block to catch the error and check the error message.
        try{
            Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundaryGroupToAddTo`'*"
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }
    }

    #Test correct errors are returned when the BoundaryName parameter is erroneous

    Context "IP Subnet errors - boundary already exists." {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = 'Test - Boundary - 1'
            BoundarySubnetIdCidr = '100.100.100.128/25'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{

            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs

        }catch{

            $lastError = $Error[0].ToString()

        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        #Check that all the components of the 3 existing boundaries are in the error message.
        If($lastError -like "$($erroneousIpSubnetInputs.BoundaryName) is an existing SCCM boundary*" -and
        $lastError -like "*$($test1BoundaryObject.DisplayName)/IPSubnet: $($test1BoundaryObject.Value)*" -and
        $lastError -like "*$($test2BoundaryObject.DisplayName)/IPSubnet: $($test2BoundaryObject.Value)*" -and
        $lastError -like "*$($test3BoundaryObject.DisplayName)/IPRange: $($test3BoundaryObject.Value)*"){

            $correctErrorMessage = $true

        }else{

            $correctErrorMessage = $false

        }

        It "Should throw the correct error message." {
            $correctErrorMessage | Should -BeTrue
        }

        It "Should throw correct error exception." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} |
            Should -Throw -ExceptionType 'System.ArgumentException'
        }
    }

    Context "IP Subnet errors - boundary is null." {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = $null
            BoundarySubnetIdCidr = '100.100.100.128/25'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} | Should -Throw
        }

        #Use a Try block to catch the error and check the error message.
        try{
            Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundaryName`'*"
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }
    }

    Context "IP Subnet errors - boundary is empty." {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = ''
            BoundarySubnetIdCidr = '100.100.100.128/25'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} | Should -Throw
        }

        #Use a Try block to catch the error and check the error message.
        try{
            Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundaryName`'*"
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }
    }

    #Test correct errors are returned when Subnet ID is erroneous.

    Context "IP Subnet errors - Subnet ID is null." {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName ='Test - Boundary - 4'
            BoundarySubnetIdCidr = $null
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} | Should -Throw
        }

        #Use a Try block to catch the error and check the error message.
        try{
            Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundarySubnetIdCidr`'*"
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }
    }

    Context "IP Subnet errors - Subnet ID is empty." {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName ='Test - Boundary - 4'
            BoundarySubnetIdCidr = ''
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} | Should -Throw
        }

        #Use a Try block to catch the error and check the error message.
        try{
            Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundarySubnetIdCidr`'*"
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }
    }

    Context "IP Subnet errors - Subnet ID has invalid IP address 1" {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName ='Test - Boundary - 4'
            BoundarySubnetIdCidr = '100.1000.100.128/25'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw correct error message and exception." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} |
            Should -Throw "$($erroneousIpSubnetInputs.BoundarySubnetIdCidr) is not a valid IPv4 CIDR subnet ID." `
            -ExceptionType 'System.ArgumentException'
        }
    }

    Context "IP Subnet errors - Subnet ID has invalid IP address 2" {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName ='Test - Boundary - 4'
            BoundarySubnetIdCidr = '100.-5.100.128/25'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw correct error message and exception." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} |
            Should -Throw "$($erroneousIpSubnetInputs.BoundarySubnetIdCidr) is not a valid IPv4 CIDR subnet ID." `
            -ExceptionType 'System.ArgumentException'
        }
    }

    Context "IP Subnet errors - Subnet ID has invalid IP address 3" {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName ='Test - Boundary - 4'
            BoundarySubnetIdCidr = '100.100.128/25'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw correct error message and exception." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} |
            Should -Throw "$($erroneousIpSubnetInputs.BoundarySubnetIdCidr) is not a valid IPv4 CIDR subnet ID." `
            -ExceptionType 'System.ArgumentException'
        }
    }

    Context "IP Subnet errors - Subnet ID has invalid number of network bits 1" {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName ='Test - Boundary - 4'
            BoundarySubnetIdCidr = '100.100.100.128/100'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw correct error message and exception." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} |
            Should -Throw "$($erroneousIpSubnetInputs.BoundarySubnetIdCidr) is not a valid IPv4 CIDR subnet ID." `
            -ExceptionType 'System.ArgumentException'
        }
    }

    Context "IP Subnet errors - Subnet ID has invalid number of network bits 2" {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName ='Test - Boundary - 4'
            BoundarySubnetIdCidr = '100.100.100.128/10.6'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw correct error message and exception." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} |
            Should -Throw "$($erroneousIpSubnetInputs.BoundarySubnetIdCidr) is not a valid IPv4 CIDR subnet ID." `
            -ExceptionType 'System.ArgumentException'
        }
    }

    Context "IP Subnet errors - Subnet ID has invalid number of network bits 3" {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName ='Test - Boundary - 4'
            BoundarySubnetIdCidr = '100.100.100.128/'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw correct error message and exception." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} |
            Should -Throw "$($erroneousIpSubnetInputs.BoundarySubnetIdCidr) is not a valid IPv4 CIDR subnet ID." `
            -ExceptionType 'System.ArgumentException'
        }
    }

    Context "IP Subnet errors - Subnet ID has invalid number of network bits 4" {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName ='Test - Boundary - 4'
            BoundarySubnetIdCidr = '100.100.100.128'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw correct error message and exception." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} |
            Should -Throw "$($erroneousIpSubnetInputs.BoundarySubnetIdCidr) is not a valid IPv4 CIDR subnet ID." `
            -ExceptionType 'System.ArgumentException'
        }
    }

    Context "IP Subnet errors - Subnet ID has invalid number of network bits 5" {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName ='Test - Boundary - 4'
            BoundarySubnetIdCidr = '100.100.100.128/-10'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw correct error message and exception." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} |
            Should -Throw "$($erroneousIpSubnetInputs.BoundarySubnetIdCidr) is not a valid IPv4 CIDR subnet ID." `
            -ExceptionType 'System.ArgumentException'
        }
    }

    #Test that the correct errors are returned when creating boundaries using erroneous IP ranges.

    #Test correct errors are returned when the BoundaryGroupToAddTo parameter is erroneous

    # Context "IP range errors - boundary group does not exist." {

    #     #Context specific mock.

    #     Mock Get-CMBoundaryGroup {New-Object -TypeName PSObject -Property @{Name = 'Test Group'}}`
    #     -ModuleName 'SCCMBoundaryTools'

    #     Mock Get-CMBoundaryGroup {'Test Group'} -ParameterFilter {$Name -and $Name -eq 'Test Group'}`
    #     -ModuleName 'SCCMBoundaryTools'

    #     Mock Get-CMBoundaryGroup {$null} -ParameterFilter {$Name -and $Name -ne 'Test Group' -and $Name -ne $null}`
    #     -ModuleName 'SCCMBoundaryTools'

    #     $erroneousIpRangeInputs = @{
    #         BoundaryGroupToAddTo = "Some group that doesn't exist"
    #         BoundaryName = 'Test - Boundary - 4'
    #         BoundaryRangeStartIp = '100.35.63.35'
    #         BoundaryRangeEndIp = '100.35.63.98'
    #     }

    #     #See if $functionOutput is occupied, if it is clear it.
    #     if($functionOutput){
    #         Remove-Variable -Name functionOutput
    #     }

    #     <#
    #     See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
    #     Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
    #     #>
    #     try{
    #         $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
    #     }catch{
    #     }

    #     It "Should not create a new boundary." {
    #         $functionOutput| Should -BeNullOrEmpty
    #     }


    #     $errorMessage = (
    #         "$($erroneousIpRangeInputs.BoundaryGroupToAddTo) is not an existing SCCM boundary group." +
    #         " The following are existing groups:" +
    #         " Test Group."
    #     )

    #     It "Should throw correct error message and exception." {
    #         {Create-SCCMBoundary @erroneousIpRangeInputs} |
    #         Should -Throw $errorMessage -ExceptionType 'System.ArgumentException'
    #     }
    # }

    Context "IP range errors - boundary group is null." {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = $null
            BoundaryName = 'Test - Boundary - 4'
            BoundaryRangeStartIp = '100.35.63.35'
            BoundaryRangeEndIp = '100.35.63.98'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} | Should -Throw
        }

        #Use a Try block to catch the error and check the error message.
        try{
            Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundaryGroupToAddTo`'*"
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }
    }

    Context "IP range errors - boundary group is empty." {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = ''
            BoundaryName = 'Test - Boundary - 4'
            BoundaryRangeStartIp = '100.35.63.35'
            BoundaryRangeEndIp = '100.35.63.98'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} | Should -Throw
        }

        #Use a Try block to catch the error and check the error message.
        try{
            Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundaryGroupToAddTo`'*"
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }
    }

    #Test correct errors are returned when the BoundaryName parameter is erroneous

    Context "IP range errors - boundary already exists." {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = 'Test - Boundary - 1'
            BoundaryRangeStartIp = '100.35.63.35'
            BoundaryRangeEndIp = '100.35.63.98'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{

            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs

        }catch{

            $lastError = $Error[0].ToString()

        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        #Check that all the components of the 3 existing boundaries are in the error message.
        If($lastError -like "$($erroneousIpRangeInputs.BoundaryName) is an existing SCCM boundary*" -and
        $lastError -like "*$($test1BoundaryObject.DisplayName)/IPSubnet: $($test1BoundaryObject.Value)*" -and
        $lastError -like "*$($test2BoundaryObject.DisplayName)/IPSubnet: $($test2BoundaryObject.Value)*" -and
        $lastError -like "*$($test3BoundaryObject.DisplayName)/IPRange: $($test3BoundaryObject.Value)*"){

            $correctErrorMessage = $true

        }else{

            $correctErrorMessage = $false

        }

        It "Should throw the correct error message." {
            $correctErrorMessage | Should -BeTrue
        }

        It "Should throw correct error message and exception." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} |
            Should -Throw -ExceptionType 'System.ArgumentException'
        }
    }

    Context "IP range errors - boundary is null." {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = $null
            BoundaryRangeStartIp = '100.35.63.35'
            BoundaryRangeEndIp = '100.35.63.98'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} | Should -Throw
        }

        #Use a Try block to catch the error and check the error message.
        try{
            Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundaryName`'*"
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }
    }

    Context "IP range errors - boundary is empty." {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = ''
            BoundaryRangeStartIp = '100.35.63.35'
            BoundaryRangeEndIp = '100.35.63.98'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} | Should -Throw
        }

        #Use a Try block to catch the error and check the error message.
        try{
            Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundaryName`'*"
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }
    }

    #Test that the correct errors are returned when the starting IP address is erroneous

    Context "IP range errors - Starting IP address is null." {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = 'Test - Boundary - 4'
            BoundaryRangeStartIp = $null
            BoundaryRangeEndIp = '100.35.63.98'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} | Should -Throw
        }

        #Use a Try block to catch the error and check the error message.
        try{
            Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundaryRangeStartIp`'*"
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }
    }

    Context "IP range errors - Starting IP address is empty." {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = 'Test - Boundary - 4'
            BoundaryRangeStartIp = ''
            BoundaryRangeEndIp = '100.35.63.98'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} | Should -Throw
        }

        #Use a Try block to catch the error and check the error message.
        try{
            Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundaryRangeStartIp`'*"
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }
    }

    Context "IP range errors - Invalid starting IP address - 1" {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = 'Test - Boundary - 4'
            BoundaryRangeStartIp = '100.35.63.3500'
            BoundaryRangeEndIp = '100.35.63.98'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw correct error message and exception." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} |
            Should -Throw "The starting IP, $($erroneousIpRangeInputs.BoundaryRangeStartIp), is not a valid IPv4 address." `
            -ExceptionType 'System.ArgumentException'
        }
    }

    Context "IP range errors - Invalid starting IP address - 2" {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = 'Test - Boundary - 4'
            BoundaryRangeStartIp = '100.35.63.-9'
            BoundaryRangeEndIp = '100.35.63.98'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw correct error message and exception." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} |
            Should -Throw "The starting IP, $($erroneousIpRangeInputs.BoundaryRangeStartIp), is not a valid IPv4 address." `
            -ExceptionType 'System.ArgumentException'
        }
    }

    Context "IP range errors - Invalid starting IP address - 3" {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = 'Test - Boundary - 4'
            BoundaryRangeStartIp = '100.35.63'
            BoundaryRangeEndIp = '100.35.63.98'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw correct error message and exception." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} |
            Should -Throw "The starting IP, $($erroneousIpRangeInputs.BoundaryRangeStartIp), is not a valid IPv4 address." `
            -ExceptionType 'System.ArgumentException'
        }
    }

    #Test that the correct errors are returned when the ending IP address is erroneous

    Context "IP range errors - Ending IP address is null." {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = 'Test - Boundary - 4'
            BoundaryRangeStartIp = '100.35.63.98'
            BoundaryRangeEndIp = $null
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} | Should -Throw
        }

        #Use a Try block to catch the error and check the error message.
        try{
            Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundaryRangeEndIp`'*"
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }
    }

    Context "IP range errors - Ending IP address is empty." {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = 'Test - Boundary - 4'
            BoundaryRangeStartIp = '100.35.63.98'
            BoundaryRangeEndIp = ''
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} | Should -Throw
        }

        #Use a Try block to catch the error and check the error message.
        try{
            Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundaryRangeEndIp`'*"
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }
    }

    Context "IP range errors - Invalid ending IP address - 1" {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = 'Test - Boundary - 4'
            BoundaryRangeStartIp = '100.35.63.35'
            BoundaryRangeEndIp = '100.35.63.9800'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw correct error message and exception." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} |
            Should -Throw "The ending IP, $($erroneousIpRangeInputs.BoundaryRangeEndIp), is not a valid IPv4 address." `
            -ExceptionType 'System.ArgumentException'
        }
    }

    Context "IP range errors - Invalid ending IP address - 2" {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = 'Test - Boundary - 4'
            BoundaryRangeStartIp = '100.35.63.9'
            BoundaryRangeEndIp = '100.35.63.-98'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw correct error message and exception." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} |
            Should -Throw "The ending IP, $($erroneousIpRangeInputs.BoundaryRangeEndIp), is not a valid IPv4 address." `
            -ExceptionType 'System.ArgumentException'
        }
    }

    Context "IP range errors - Invalid ending IP address - 3" {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = 'Test - Boundary - 4'
            BoundaryRangeStartIp = '100.35.63.56'
            BoundaryRangeEndIp = '100.98'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw correct error message and exception." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} |
            Should -Throw "The ending IP, $($erroneousIpRangeInputs.BoundaryRangeEndIp), is not a valid IPv4 address." `
            -ExceptionType 'System.ArgumentException'
        }
    }

    Context "Boundary was not created correctly." {

        $ipSubnetInputs = @{
            BoundaryGroupToAddTo = 'Test Group'
            BoundaryName = 'Test - Boundary - 4'
            BoundarySubnetIdCidr = '100.100.100.128/25'
        }

        #Mock boundary delete check to return as result indicating the boundary has not been deleted correctly.
        Mock Check-SCCMBoundaryCreate {$false} -ModuleName 'SCCMBoundaryTools'

        $expectedErrorMessage = "Boundary '$($ipSubnetInputs.BoundaryName)' was not created correctly."
        $expectedErrorException = 'System.NotImplementedException'

        It "Should throw the correct error" {
            {Create-SCCMBoundary @ipSubnetInputs} |
            Should -Throw -ExpectedMessage $expectedErrorMessage -ExceptionType $expectedErrorException
        }

    }

    Context "Boundary creation could not be verified." {

        $ipSubnetInputs = @{
            BoundaryGroupToAddTo = 'Test Group'
            BoundaryName = 'Test - Boundary - 4'
            BoundarySubnetIdCidr = '100.100.100.128/25'
        }

        #Mock boundary delete check to return error indicating verification failed.

        [string] $Global:errorMessage = (
            "Could not confirm '$($ipSubnetInputs.BoundaryName)' was created. " +
            "Please check that it was created correctly."
        )

        Mock Check-SCCMBoundaryCreate {
            $PSCmdlet.ThrowTerminatingError(
                [System.Management.Automation.ErrorRecord]::new(
                    ([System.NotImplementedException] $errorMessage),
                    'CreateValidateFailed',
                    [System.Management.Automation.ErrorCategory]::OpenError,
                    $functionInputSplat.BoundaryName
                )
            )
        } -ModuleName 'SCCMBoundaryTools'

        $expectedErrorMessage = "Could not confirm '$($ipSubnetInputs.BoundaryName)' was created. Please check that it was created correctly."
        $expectedErrorException = 'System.NotImplementedException'

        It "Should throw the correct error" {
            {Create-SCCMBoundary @ipSubnetInputs} |
            Should -Throw -ExpectedMessage $expectedErrorMessage -ExceptionType $expectedErrorException
        }
    }
}

Describe "Test with SCCM objects." -Tag "SCCM Test" {

    #Set set the path so SCCM commands can run against SCCM
    Set-Location -Path CAS:

    #Delete boundaries with the same names as used in the tests.

    $namesToCheck = @(
        'Test - Boundary - 1'
        'Test - Boundary - 2'
        'Test - Boundary - 3'
        'Test - Boundary - 4'
    )

    $valuesToCheck = @(
        '100.100.100.128'
        '100.35.63.35-100.35.63.98'
        '200.100.100.128'
    )

    $boundariesToDelete = Get-CMBoundary |
    Where-Object -FilterScript {
        ($_.Name -in $namesToCheck -or $_.value -in $valuesToCheck) -and
        ($_.Name -notlike "*EUC*")
    }

    foreach($boundary in $boundariesToDelete){

        Remove-CMBoundary -InputObject $boundary -Force

    }

    <#
    Run a test that calls cmdlets in the ConfigurationManager console. As the previous tests mocked thse cmdlets
    inputs to the function have been confirmed to flow through the function correctly. The following tests use
    ConfigurationManager cmdlets to test they that are being called and used correctly in the function. The tests
    will ensure all features of the funtion that rely on the ConfigurationManager module behave as expected.
    #>


    #Test correct boundary creation process using IP subnets.

    Context "Test boundary creation with IP subnets." {

        #Test that correct boundary will be created when using IP subnets.

        $ipSubnetInputs = @{
            BoundaryGroupToAddTo = 'Test Group'
            BoundaryName = 'Test - Boundary - 1'
            BoundarySubnetIdCidr = '100.100.100.128/25'
        }

        #Clear $functionOutput if occupied to make sure null or empty results are saved to the variable properly.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        #Get the function output to test the output is correct
        $functionOutput = Create-SCCMBoundary @ipSubnetInputs

        #Use Get-CMBoundary to query and return the created object from SCCM to test it has been created correctly
        $createdBoundaryObject = Get-CMBoundary -BoundaryName $ipSubnetInputs.BoundaryName

        <#
        Search for the created boundary only by searching the the $ipSubnetInputs.BoundaryGroupToAddTo to ensure
        that the created boundary was added to the correct boundary group.
        #>
        $boundaryInBoundaryGroup = Get-CMBoundary -BoundaryGroupName $ipSubnetInputs.BoundaryGroupToAddTo |
        Where-Object -FilterScript {$_.DisplayName -eq $ipSubnetInputs.BoundaryName}

        It "Output should not be null or empty." {
            $functionOutput | Should -Not -BeNullOrEmpty
        }

        It "Should output an SCCM boundary object." {
            ($functionOutput | gm).TypeName[0] | Should -Be 'IResultObject#SMS_Boundary'
        }

        It "Should output the boundary object created." {
            $functionOutput.BoundaryID | Should -Be $createdBoundaryObject.BoundaryID
        }

        It "Should create a boundary with the correct name." {
            $functionOutput.DisplayName | Should -Be "$($ipSubnetInputs.BoundaryName)"
        }

        #Convert $ipSubnetInputs.BoundarySubnetIdCidr into a network ID to compare to value of boundary created.

        $subnetID = Convert-CIDRToSubnetId -CIDRAddress $ipSubnetInputs.BoundarySubnetIdCidr

        It "Should create a boundary with the correct value." {
            $functionOutput.Value | Should -Be $subnetID
        }

        It "Should move the boundary to the correct boundary group." {
            $functionOutput.BoundaryID | Should -Be $boundaryInBoundaryGroup.BoundaryID
        }
    }

    #Test correct boundary creation creation process using an IP range.

    Context "Test boundary creation with an IP range." {

        $ipRangeInputs = @{
            BoundaryGroupToAddTo = 'Test Group'
            BoundaryName = 'Test - Boundary - 2'
            BoundaryRangeStartIp = '100.35.63.35'
            BoundaryRangeEndIp = '100.35.63.98'
        }

        #Clear $functionOutput if occupied to make sure null or empty results are saved to the variable properly.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        #Get the function output to test the output is correct
        $functionOutput = Create-SCCMBoundary @ipRangeInputs

        #Use Get-CMBoundary to query and return the created object from SCCM to test it has been created correctly
        $createdBoundaryObject = Get-CMBoundary -BoundaryName $ipRangeInputs.BoundaryName


        <#
        Search for the created boundary only by searching the the $ipRangeInputs.BoundaryGroupToAddTo to ensure
        that the created boundary was added to the correct boundary group.
        #>
        $boundaryInBoundaryGroup = Get-CMBoundary -BoundaryGroupName $ipRangeInputs.BoundaryGroupToAddTo |
        Where-Object -FilterScript {$_.DisplayName -eq $ipRangeInputs.BoundaryName}

        It "Output should not be null or empty." {
            $functionOutput | Should -Not -BeNullOrEmpty
        }

        It "Should output an SCCM boundary object." {
            ($functionOutput | gm).TypeName[0] | Should -Be 'IResultObject#SMS_Boundary'
        }

        It "Should output the boundary object created." {
            $functionOutput.BoundaryID | Should -Be $createdBoundaryObject.BoundaryID
        }

        It "Should create a boundary with the correct name." {
            $functionOutput.DisplayName | Should -Be "$($ipRangeInputs.BoundaryName)"
        }

        It "Should create a boundary with the correct value." {
            $functionOutput.Value |
            Should -Be "$($ipRangeInputs.BoundaryRangeStartIp)-$($ipRangeInputs.BoundaryRangeEndIp)"
        }

        It "Should move the boundary to the correct boundary group." {
            $functionOutput.BoundaryID | Should -Be $boundaryInBoundaryGroup.BoundaryID
        }
    }

    #Test that the correct errors are returned when creating boundaries using erroneous IP subnets.

    #Test correct errors are returned when the BoundaryGroupToAddTo parameter is erroneous

    Context "IP Subnet errors - boundary group does not exist." {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = "Some group that doesn't exist"
            BoundaryName = 'Test - Boundary - 3'
            BoundarySubnetIdCidr = '200.100.100.128/25'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        if($lastError -like "$($erroneousIpSubnetInputs.BoundaryGroupToAddTo) is not an existing SCCM boundary group.*" -and
        $lastError -like "*The following are existing groups:*" -and
        $lastError -like "*Test Group*"){
            $correctError = $true
        }else{
            $correctError = $false
        }

        It "Should throw correct error message." {
            $correctError | Should -BeTrue
        }

        It "Should throw correct exception." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} |
            Should -Throw -ExceptionType 'System.ArgumentException'
        }
    }

    Context "IP Subnet errors - boundary group is null." {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = $null
            BoundaryName = 'Test - Boundary - 3'
            BoundarySubnetIdCidr = '200.100.100.128/25'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} | Should -Throw
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundaryGroupToAddTo`'*"
        }

    }

    Context "IP Subnet errors - boundary group is empty." {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = ''
            BoundaryName = 'Test - Boundary - 3'
            BoundarySubnetIdCidr = '200.100.100.128/25'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>

        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} | Should -Throw
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundaryGroupToAddTo`'*"
        }
    }

    #Test correct errors are returned when the BoundaryName parameter is erroneous

    Context "IP Subnet errors - boundary already exists." {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = 'Test - Boundary - 1'
            BoundarySubnetIdCidr = '200.100.100.128/25'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        #See if $lastError is occupied, if it is clear it.
        if($lastError){
            Remove-Variable -Name lastError
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        if($lastError -like "$($erroneousIpSubnetInputs.BoundaryName) is an existing SCCM boundary.*"){
            $correctError = $true
        }else{
            $correctError = $false
        }

        It "Should throw the correct error message."{
            $correctError | Should -BeTrue
        }


        It "Should throw correct exception." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} |
            Should -Throw -ExceptionType 'System.ArgumentException'
        }
    }

    Context "IP Subnet errors - boundary is null." {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = $null
            BoundarySubnetIdCidr = '200.100.100.128/25'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} | Should -Throw
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundaryName`'*"
        }
    }

    Context "IP Subnet errors - boundary is empty." {

        $erroneousIpSubnetInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = ''
            BoundarySubnetIdCidr = '200.100.100.128/25'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpSubnetInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpSubnetInputs} | Should -Throw
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundaryName`'*"
        }
    }

    #Test correct errors are returned when the BoundaryGroupToAddTo parameter is erroneous

    Context "IP range errors - boundary group does not exist." {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = "Some group that doesn't exist"
            BoundaryName = 'Test - Boundary - 4'
            BoundaryRangeStartIp = '100.35.63.35'
            BoundaryRangeEndIp = '100.35.63.98'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        if($lastError -like "$($erroneousIpRangeInputs.BoundaryGroupToAddTo) is not an existing SCCM boundary group.*" -and
        $lastError -like "*The following are existing groups:*" -and
        $lastError -like "*Test Group*"){
            $correctError = $true
        }else{
            $correctError = $false
        }

        It "Should throw correct error message." {
            $correctError | Should -BeTrue
        }

        It "Should throw correct exception." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} |
            Should -Throw -ExceptionType 'System.ArgumentException'
        }
    }

    Context "IP range errors - boundary group is null." {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = $null
            BoundaryName = 'Test - Boundary - 4'
            BoundaryRangeStartIp = '100.35.63.35'
            BoundaryRangeEndIp = '100.35.63.98'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} | Should -Throw
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundaryGroupToAddTo`'*"
        }
    }

    Context "IP range errors - boundary group is empty." {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = ''
            BoundaryName = 'Test - Boundary - 4'
            BoundaryRangeStartIp = '100.35.63.35'
            BoundaryRangeEndIp = '100.35.63.98'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} | Should -Throw
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundaryGroupToAddTo`'*"
        }
    }

    #Test correct errors are returned when the BoundaryName parameter is erroneous

    Context "IP range errors - boundary already exists." {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = 'Test - Boundary - 1'
            BoundaryRangeStartIp = '100.35.63.35'
            BoundaryRangeEndIp = '100.35.63.98'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        if($lastError -like "$($erroneousIpRangeInputs.BoundaryName) is an existing SCCM boundary.*"){
            $correctError = $true
        }else{
            $correctError = $false
        }

        It "Should throw the correct error message."{
            $correctError | Should -BeTrue
        }


        It "Should throw correct exception." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} |
            Should -Throw -ExceptionType 'System.ArgumentException'
        }
    }

    Context "IP range errors - boundary is null." {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = $null
            BoundaryRangeStartIp = '100.35.63.35'
            BoundaryRangeEndIp = '100.35.63.98'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} | Should -Throw
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundaryName`'*"
        }
    }

    Context "IP range errors - boundary is empty." {

        $erroneousIpRangeInputs = @{
            BoundaryGroupToAddTo = "Test Group"
            BoundaryName = ''
            BoundaryRangeStartIp = '100.35.63.35'
            BoundaryRangeEndIp = '100.35.63.98'
        }

        #See if $functionOutput is occupied, if it is clear it.
        if($functionOutput){
            Remove-Variable -Name functionOutput
        }

        #If $lastError is occupied then clear it
        if($lastError){
            Remove-Variable -Name lastError
        }

        <#
        See if Create-SCCMBoundary creates a boundary, if it does it will produce an output.
        Use an error block so if an error occurs as expected the Describe block doesn't stop executing.
        #>
        try{
            $functionOutput = Create-SCCMBoundary @erroneousIpRangeInputs
        }catch{
            $lastError = $Error[0].ToString()
        }

        It "Should not create a new boundary." {
            $functionOutput| Should -BeNullOrEmpty
        }

        It "Should throw error." {
            {Create-SCCMBoundary @erroneousIpRangeInputs} | Should -Throw
        }

        It "Should throw error on correct parameter." {
            $lastError | Should -BeLike "Cannot validate argument on parameter `'BoundaryName`'*"
        }
    }
}

###################################################################################################################
##### 115 character width indicator #####
###################################################################################################################
