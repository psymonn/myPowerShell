#region Setting up the VM

## Be as specific as possible defining parameters. This allows you to easily see each 
## configuration item in the script so tests can be built around it.

$vmName = 'TESTDC'
$hyperVHostName = 'HYPERVSRV'

## Create the VM
$newVmParams = @{
    Name = $vmName
    MemoryStartupBytes = 4GB
    Generation = 1
    SwitchName = 'LabSwitch'
    Path = 'C:\VMs'
    ComputerName = $hyperVHostName
}

New-VM @newVMParams

## Create and add the VHD to the VM

if (Test-Path -Path "\\$hyperVHostName\c$\VHDs\TESTDC.vhdx" -PathType Leaf) 
{
    throw 'There is already an existing VHD created for the VM'    
}

$newVhdParams = @{
    Path = 'C:\VHDs\TESTDC.vhdx'
    Dynamic = $true
    SizeBytes = 40GB
    ComputerName = $hyperVHostName
}

$vhd = New-Vhd @newVhdParams

$addHdParams = @{
    VMName = $vmName
    Path = $vhd.Path
    ComputerName = $hyperVHostName
}

Add-VMHardDiskDrive @addHdParams

#endregion

#region Get the OS installed

## We've already created the AutoUnattend.xml file and placed it in the root of the ISO file. This will ensure Windows
## is a standardized install.

$isoPath = 'D:\ISOs\Server2012R2.iso'
$ipAddress = '192.168.0.156' ## This is from the AutoUnattend.xml file
Set-VMDvdDrive -ComputerName $hyperVHostName -VMName $vmName -Path $isoPath

## This will kick off the OS install
Start-VM -VMName $vmName -ComputerName $hyperVHostName

#endregion

#region Setup AD

while (-not (Test-Connection -ComputerName $vmName -Quiet -Count 1)) {
    Start-Sleep -Seconds 1
}

## Add the VM to local trusted hosts so I can connect to it via PowerShell remoting
set-item wsman:\localhost\Client\TrustedHosts -value $vmName -Force

$credential = Get-Credential -Message "Specify the username and password to connect to [$($vmName)]"

## Install the bits for Active Directory Domain Services
$installFeatureParams = @{
    Name = 'AD-Domain-Services'
    IncludeManagementTools = $true
    IncludeAllSubFeature = $true
}
icm -ComputerName $vmName -Credential $credential -ScriptBlock {Install-WindowsFeature @using:installFeatureParams}
 
# Create New Forest and Domain Controller
$scriptBlock = {
    $domainname = 'test.local'
    $netbiosName = 'TEST'
    Import-Module ADDSDeployment
    
    $ad_params = @{
        CreateDnsDelegation=$false
        DatabasePath='C:\NTDS'
        DomainMode='Win2012'
        DomainName=$domainname
        DomainNetbiosName=$netbiosName
        ForestMode='Win2012'
        InstallDns=$true
        NoRebootOnCompletion=$false
        Force=$true
        SafeModeAdministratorPassword=(ConvertTo-SecureString 'p@$$w0rd12' -AsPlainText -Force)
    }
    
    Install-ADDSForest @ad_params
}
Invoke-Command -ComputerName $vmName -ScriptBlock $scriptBlock -Credential $credential

#endregion