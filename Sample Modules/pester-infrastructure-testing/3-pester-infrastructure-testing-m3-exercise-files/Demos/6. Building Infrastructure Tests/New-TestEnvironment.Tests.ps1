describe 'New-TestEnvironment' {

    $jsonPath = "C:\Dropbox\Business Projects\Courses\Pluralsight\Course Authoring\Active Courses\pester-infrastructure-testing\pester-infrastructure-testing-m2\Demos\8. Building Infrastructure Tests\ConfigurationItems.json"
    
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
    
    
    context 'Virtual Machines' {
        
        ## Shared variables up here
        $hyperVHostName = 'HYPERVSRV'

        ## Gather all VM attributes first
        $vm = Get-VM -Name (Get-ExpectedValue -Path 'VirtualMachine\Name') -ComputerName $hyperVHostName
        $vhd = $vm | Get-VMHardDiskDrive

        it 'creates the VM with the right name' {
            $vm.Name | should be (Get-ExpectedValue -Path 'VirtualMachine\Name')
        }

        it 'assigns the correct memory' {
            $memoryStartup = $vm.MemoryStartup / 1GB
            $memoryStartup = '{0}{1}' -f $memoryStartup,'GB'
            $memoryStartup | should be (Get-ExpectedValue -Path 'VirtualMachine\Memory')
        }

        it 'creates a generation 1 VM' {
            $vm.Generation | should be (Get-ExpectedValue -Path 'VirtualMachine\Generation')
        }

        it 'attaches the right switch to the VM' {
            $vm.NetworkAdapters.SwitchName| should be (Get-ExpectedValue -Path 'VirtualMachine\SwitchName')
        }

        it 'creates the VM in the right location' {
            $basePath = Get-ExpectedValue -Path 'VirtualMachine\Path'
            $vmName = Get-ExpectedValue -Path 'VirtualMachine\Name'
            $vm.Path | should be "$basePath\$vmName"
        }

        it 'creates a VHD in the right location' {
            $vhd.Path | should be (Get-ExpectedValue -Path 'VirtualMachine\VHD\Path')
        }

        it 'creates a VHD that is Dynamic' {
            $vhdType = Invoke-Command -ComputerName $hyperVHostName -ScriptBlock {
                            (Get-Vhd $using:vhd.Path).VhdType
                        } | Select -ExpandProperty Value
            $vhdType -eq 'Dynamic' | should be (Get-ExpectedValue -Path 'VirtualMachine\VHD\Dynamic')
        }

        it 'creates a VHD that is the correct size' {
            $vhdSize = Invoke-Command -ComputerName $hyperVHostName -ScriptBlock {
                            (Get-Vhd $using:vhd.Path).Size
                        }
            $vhdSize = $vhdSize /1GB
            $vhdSize = '{0}{1}' -f $vhdSize,'GB'
            $vhdSize | should be (Get-ExpectedValue -Path 'VirtualMachine\VHD\Size')
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