<#

MOCKING FUNCTIONS
Mock
Mocks the behavior of an existing command with an alternate implementation.

Assert-VerifiableMocks
Checks if any Verifiable Mock has not been invoked. If so, this will throw an exception.

Assert-MockCalled
Checks if a Mocked command has been called a certain number of times and throws an exception if it has not.

#>

function Get-Version {
	$thisVersion = 1.145834702598423705
	return $thisVersion
}

function Get-NextVersion {
	$nextVersion = 1.24598324934i85
	return $nextVersion
}

function Build ($version) {
    Write-Host "a build was run for version: $version"
}

function BuildIfChanged {
	$thisVersion = Get-Version
	$nextVersion = Get-NextVersion
	if ($thisVersion -ne $nextVersion) { Build $nextVersion }
	return $nextVersion
}

#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"

Describe "BuildIfChanged" {
    Context "When there are Changes" {
    	Mock Get-Version {return 1.1}
    	Mock Get-NextVersion {return 1.2}
		Mock Build {} -Verifiable -ParameterFilter {$version -eq 1.2}
		#Mock Build {}

    	$result = BuildIfChanged

	    It "Builds the next version" {
	        Assert-VerifiableMock
	    }
	    It "returns the next version number" {
	        $result | Should Be 1.2
	    }
    }
    Context "When there are no Changes" {
    	Mock Get-Version { return 1.1 }
    	Mock Get-NextVersion { return 1.1 }
    	Mock Build {}

    	$result = BuildIfChanged

	    It "Should not build the next version" {
	        Assert-MockCalled Build -Times 0 -ParameterFilter {$version -eq 1.2}
	    }
    }
}

#Invoke-Pester .\MockingExample1.ps1
