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

    context 'Virtual Machines' {
        
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

        function Get-ProductKey {
            <#   
            .SYNOPSIS   
                Retrieves the product key and OS information from a local or remote system/s.
                
            .DESCRIPTION   
                Retrieves the product key and OS information from a local or remote system/s. Queries of 64bit OS from a 32bit OS will result in 
                inaccurate data being returned for the Product Key. You must query a 64bit OS from a system running a 64bit OS.
                
            .PARAMETER Computername
                Name of the local or remote system/s.
                
            .NOTES   
                Author: Boe Prox
                Version: 1.1       
                    -Update of function from http://powershell.com/cs/blogs/tips/archive/2012/04/30/getting-windows-product-key.aspx
                    -Added capability to query more than one system
                    -Supports remote system query
                    -Supports querying 64bit OSes
                    -Shows OS description and Version in output object
                    -Error Handling
            
            .EXAMPLE 
            Get-ProductKey -Computername Server1
            
            OSDescription                                           Computername OSVersion ProductKey                   
            -------------                                           ------------ --------- ----------                   
            Microsoft(R) Windows(R) Server 2003, Enterprise Edition Server1       5.2.3790  bcdfg-hjklm-pqrtt-vwxyy-12345     
                
                Description 
                ----------- 
                Retrieves the product key information from 'Server1'
            #>         
            [cmdletbinding()]
            Param (
                [parameter(ValueFromPipeLine=$True,ValueFromPipeLineByPropertyName=$True)]
                [Alias("CN","__Server","IPAddress","Server")]
                [string[]]$Computername = $Env:Computername
            )
            Begin {   
                $map="BCDFGHJKMPQRTVWXY2346789" 
            }
            Process {
                ForEach ($Computer in $Computername) {
                    Write-Verbose ("{0}: Checking network availability" -f $Computer)
                    If (Test-Connection -ComputerName $Computer -Count 1 -Quiet) {
                        Try {
                            Write-Verbose ("{0}: Retrieving WMI OS information" -f $Computer)
                            $OS = Get-WmiObject -ComputerName $Computer Win32_OperatingSystem -ErrorAction Stop                
                        } Catch {
                            $OS = New-Object PSObject -Property @{
                                Caption = $_.Exception.Message
                                Version = $_.Exception.Message
                            }
                        }
                        Try {
                            Write-Verbose ("{0}: Attempting remote registry access" -f $Computer)
                            $remoteReg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine,$Computer)
                            If ($OS.OSArchitecture -eq '64-bit') {
                                $value = $remoteReg.OpenSubKey("SOFTWARE\Microsoft\Windows NT\CurrentVersion").GetValue('DigitalProductId4')[0x34..0x42]
                            } Else {                        
                                $value = $remoteReg.OpenSubKey("SOFTWARE\Microsoft\Windows NT\CurrentVersion").GetValue('DigitalProductId')[0x34..0x42]
                            }
                            $ProductKey = ""  
                            Write-Verbose ("{0}: Translating data into product key" -f $Computer)
                            for ($i = 24; $i -ge 0; $i--) { 
                            $r = 0 
                            for ($j = 14; $j -ge 0; $j--) { 
                                $r = ($r * 256) -bxor $value[$j] 
                                $value[$j] = [math]::Floor([double]($r/24)) 
                                $r = $r % 24 
                            } 
                            $ProductKey = $map[$r] + $ProductKey 
                            if (($i % 5) -eq 0 -and $i -ne 0) { 
                                $ProductKey = "-" + $ProductKey 
                            } 
                            }
                        } Catch {
                            $ProductKey = $_.Exception.Message
                        }        
                        $object = New-Object PSObject -Property @{
                            Computername = $Computer
                            ProductKey = $ProductKey
                            OSDescription = $os.Caption
                            OSVersion = $os.Version
                        } 
                        $object.pstypenames.insert(0,'ProductKey.Info')
                        $object
                    } Else {
                        $object = New-Object PSObject -Property @{
                            Computername = $Computer
                            ProductKey = 'Unreachable'
                            OSDescription = 'Unreachable'
                            OSVersion = 'Unreachable'
                        }  
                        $object.pstypenames.insert(0,'ProductKey.Info')
                        $object                           
                    }
                }
            }
        } 

        BeforeAll {
            $serverName = Get-ExpectedValue -Path 'VirtualMachine\Name'
            $adminCredential = Get-Credential -Message "Enter the username and password with rights to connect to $serverName."

            $session = New-PSSession -ComputerName $serverName -Credential $adminCredential

            $nicConfig = Invoke-Command -Session $session -ScriptBlock {
                Get-NetIPConfiguration -InterfaceIndex (Get-NetAdapter).ifIndex
            }

            $partitions = Invoke-Command -Session $session -ScriptBlock { Get-Partition }

        }

        AfterAll {
            if (Test-Path variable:\session) {
                $session | Remove-PSSession
            }
        }
        

        it 'sets the system locale to en-US' {
            Invoke-Command -Session $session -ScriptBlock {(Get-WinSystemLocale).Name} | should be 'en-US'    
        }

        it 'installs Windows Server 2012 R2 Standard' {
            Invoke-Command -Session $session -ScriptBlock {(Get-CimInstance -ClassName Win32_OperatingSystem).Caption} | should be 'Microsoft Windows Server 2012 R2 Standard'   
        }

        it 'enables the local Administrator account' {
            $administratorAccount = Invoke-Command -Session $session -ScriptBlock {
                $selectParams = @{
                    'Property' = '*', @{ Name = 'Enabled'; Expression = { -not $_.Disabled }}
                    'ExcludeProperty' = 'Disabled'
			    }
                $cimParams = @{
                    ClassName = 'Win32_UserAccount'
                    Filter = "LocalAccount = $true AND Domain = '$using:serverName' AND Name = 'Administrator'"
                }
                Get-CimInstance @cimParams | Select-Object @selectParams
            }
            $administratorAccount.Enabled | should be $true
        }

        it 'sets the local administrator account to the right password' {
            Add-Type -AssemblyName System.DirectoryServices.AccountManagement
            $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext('machine',$serverName)
            $DS.ValidateCredentials($adminCredential.UserName, $adminCredential.GetNetworkCredential().Password) | should be $true
        }

        it 'installed with the right product key' {
            (Get-ProductKey -ComputerName $serverName).ProductKey | should be (Get-ExpectedValue -Path 'OperatingSystem\ProductKey')
        }

        it 'sets the NIC IP to 192.168.0.156' {
            $nicConfig.IPv4Address.IPAddress | should be '192.168.0.156'
        }

        it 'sets the NIC DNS server to itself' {
            $nicConfig.DNSServer.Address | should be '192.168.0.156'
        }

        it 'disables the firewall' {
            $diabledProfiles = Invoke-Command -Session $session -ScriptBlock {
                Get-NetFirewallProfile | Where-Object { $_.Enabled }
            }
            $disabledProfiles | should be $null
        }

        it 'sets the PowerShell execution policy to Unrestricted' {
            (Invoke-Command -Session $session -ScriptBlock { Get-ExecutionPolicy }).Value | should be (Get-ExpectedValue -Path 'OperatingSystem\PowerShellExecutionPolicy')
        }

        it 'builds the correct disk configuration' {
            
            $expectedSystemPartition = $expectedValues.OperatingSystem.DiskConfiguration.SystemPartition
            $expectedOsPartition = $expectedValues.OperatingSystem.DiskConfiguration.OsPartition

            $systemPartition = $partitions | where {$_.IsSystem}
            $systemPartition | should not be $null
            $systemPartition.Bootable | should be $expectedSystemPartition.Bootable
            $systemPartition.FileSystem | should be $expectedSystemPartition.FileSystem
            $systemPartition.PartitionNumber | should be $expectedSystemPartition.PartitionNumber
            ($systemPartition.Size / 1MB) | should be (($expectedSystemPartition.Size -join '') -replace 'MB')
            
            $osPartition = $partitions | where {-not $_.IsSystem}
            $osPartition | should not be $null
            $osPartition.Bootable | should be $expectedOsPartition.Bootable
            $osPartition.Online | should be $expectedOsPartition.Online
            $osPartition.FileSystem | should be $expectedOsPartition.FileSystem
            $osPartition.PartitionNumber | should be $expectedOsPartition.PartitionNumber
            $osPartition.DriveLetter | should be $expectedOsPartition.DriveLetter
           [math]::Round(($osPartition.Size / 1GB),0) | should be (($expectedOsPartition.Size -join '') -replace 'GB')
        }
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