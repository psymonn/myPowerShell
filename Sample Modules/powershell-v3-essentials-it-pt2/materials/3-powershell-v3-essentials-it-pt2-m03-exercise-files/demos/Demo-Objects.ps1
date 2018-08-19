#requires -version 3.0

#demo objects in action

#region creating new objects

#using New-PSObject 
#purely for demonstration purposes
$dt = new-object system.datetime 2014,12,31
$dt
#using a type accelerator is better
[datetime]$d = "12/31/2014"
$d

#creating a custom object
$h = [ordered]@{
 Computername=$env:computername
 User=$env:username
 Domain=$env:userdomain
 Processes = (Get-Process).Count
 Running = Get-Service | where {$_.status -eq 'running'}
}

New-Object PSObject -Property $h

#using [pscustomobject]
[pscustomobject]$h

#endregion

#region COM Objects

$fso = new-object -com scripting.filesystemobject
$fso

$fso | gm

$fso.drives | where {$_.drivetype -eq 2}

$wshell = new-object -com wscript.shell
$wshell | gm Popup

#Message,Timeout,Title,Button+Icon
$wshell.Popup("It is time to learn PowerShell",0,"Attention",0+64)

#endregion

#region putting it all together

$computers = "chi-dc01","chi-dc02","chi-dc03"
$DCS = foreach ($computer in $computers) {
    $ntds = dir \\$computer\admin$\ntds\ntds.dit
    $OS = Get-WmiObject win32_operatingsystem -ComputerName $computer
    $DSLog = Get-EventLog 'Directory Service' -newest 20 -computer $computer
    $Netlogon = Get-WmiObject win32_share -filter "name='Netlogon'" -ComputerName $computer
    $Sysvol = Get-WmiObject win32_share -filter "name='SysVol'" -ComputerName $computer

    #create a custom object for each domain controller
    [pscustomobject][ordered]@{
        Computername = $os.csname
        OperatingSystem = $os.caption
        ServicePack = $os.ServicePackMajorVersion
        NTDS = $NTDS
        DSLog = $DSLog
        NetLogon = $Netlogon.Path
        SysVol = $Sysvol.path
    }
}

$dcs

$dcs | Select -expand NTDS

#or expand like this
$dcs.dslog | where {$_.entrytype -ne 'information'} | 
Select TimeGenerated,EntryType,Source,Message,
@{N="Computername";E={$_.machinename}} | Out-GridView



#endregion
