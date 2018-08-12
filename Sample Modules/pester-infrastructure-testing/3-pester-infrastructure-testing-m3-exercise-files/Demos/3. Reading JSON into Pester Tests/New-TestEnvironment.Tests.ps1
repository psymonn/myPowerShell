describe 'New-TestEnvironment' {
    
    $jsonPath = "C:\Dropbox\Business Projects\Courses\Pluralsight\Course Authoring\Active Courses\pester-infrastructure-testing\pester-infrastructure-testing-m2\Demos\3. Reading JSON into Pester Tests\ConfigurationItems.json"
    
    ## Read the JSON to gather expected values
    $expectedValues = (Get-Content $jsonPath -Raw | ConvertFrom-Json).ConfigurationItems
    
    ## All expected values are now under a single variable.
    $expectedValues

    context 'Virtual Machines' {
        it 'creates the VM with the right name' {
            'AWRONGNAME' | should be $expectedValues.VirtualMachine.Name
        }
    }

    context 'Operating System' {

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