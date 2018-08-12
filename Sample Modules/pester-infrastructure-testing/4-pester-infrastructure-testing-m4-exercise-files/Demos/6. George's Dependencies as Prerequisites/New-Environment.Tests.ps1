describe 'New-TestEnvironment' {

    $jsonPath = "C:\Dropbox\Business Projects\Courses\Pluralsight\Course Authoring\Active Courses\pester-infrastructure-testing\pester-infrastructure-testing-m3\Demos\9. Testing AutoUnattend Settings\ConfigurationItems.json"
    
    ## Read the JSON to gather expected values
    $expectedValues = (Get-Content $jsonPath -Raw | ConvertFrom-Json).ConfigurationItems

    function Get-ExpectedValue {
        param(
            [string]$Path
        )

        $split = $Path -split '\\'
        if ($split.Count -eq 2) {
            ($expectedValues | where {$_.PSObject.Properties.Name -eq $split[0]}).($split[0]).($split[1]) -join ''
        } else {
            ($expectedValues.($split[0]) | where {$_.PSObject.Properties.Name -eq $split[1]}).($split[1]).($split[2]) -join ''
        }
    }
    
    ## Shared variables up here
    $hyperVHostName = 'HYPERVSRV'

    context 'Active Directory' {

        $credential = Get-Credential -Message 'Input credential to connect to TESTDC.'

        ## Notice I'm doing a prereq test OUTSIDE of the it blocks. This is preventing the tests from even running
        ## at all. This is different than just setting the test inconclusive.
        $conditions = @(
			{ Test-Connection -ComputerName 'TESTDC' -Quiet -Count 1 }
			{ Invoke-Command -ComputerName 'TESTDC' -Credential $credential -ScriptBlock {1} -ErrorAction Ignore }
		)

		@($conditions).foreach({
			if (-not(& $_)) {
				throw 'A prereq condition was not met. Cancelling further tests.'
			}
		})

        $sharedSession = New-PSSession -ComputerName 'TESTDC' -Credential $credential
        $forest = Invoke-Command -Session $sharedSession -ScriptBlock { Get-AdForest }

        it 'creates a forest called test.local' {
            $forest.Name | should be 'test.local'
        }

        it 'sets the AD database path to C:\NTDS' {
            $dbPath = icm -Session $sharedSession -ScriptBlock { 
                $propParams = @{
                    Path = 'HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters'
                    Name = 'DSA Working Directory'
                }
                get-itemproperty @propParams | select -ExpandProperty 'DSA Working Directory'
            }
            $dbPath | should be 'C:\NTDS'
        }

        it 'sets the forest mode to Windows2012' {
            $forest.ForestMode | should be 'Windows2012Forest'
        }

        it 'sets the NewBIOS forest name to TEST' {
            $netBiosName = Invoke-Command -Session $sharedSession -ScriptBlock { Get-AdDomain } | Select -ExpandProperty NetBIOSName
            $netBiosName | should be 'TEST'
        }

        it 'installs DNS server' {
            $dnsServer = Invoke-Command -Session $sharedSession -ScriptBlock {Get-DnsServer -ErrorAction Ignore}
            $dnsServer | should not be $null
        }

        $sharedSession | Remove-PSSession
    }

    context 'AD users' {

    }

    context 'AD groups' {

    }

    context 'AD OUs' {

    }

    context 'CSV file' {

    }
}