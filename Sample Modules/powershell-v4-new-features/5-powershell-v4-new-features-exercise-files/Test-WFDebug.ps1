Workflow Test-WFDebug {

Sequence {
$regkey = get-item -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
$procCount =  Get-Process | measure-object | 
select-object -ExpandProperty count

$psversion = InlineScript {
  $PSVersionTable.psversion
}

$props =$regkey | get-itemproperty | Select-object -property Registered*,
ProductName,EditionID

write-debug -message "Properties gathered"

$hash=[ordered]@{
    PScomputername = $PSComputername
    RegisteredOwner = $props.RegisteredOwner
    RegisteredOrganization = $props.RegisteredOrganization
    ProductName = $props.ProductName
    Edition = $props.EditionID
    PSVersion = $psversion
    ProcessCount = $procCount
}

$output = New-Object -type PSobject -Property $hash

$output

} #sequence
} #workflow

# Test-WFDebug -PSComputerName chi-dc04,chi-core01

<#

#can't set breakpoint by variable. This will fail:
set-psbreakpoint -Variable regkey,proccount 

Set-PSBreakpoint -line 17 -Script S:\Test-WFDebug.ps1

#dot source the workflow
. S:\Test-WFDebug.ps1

#invoke it
test-wfdebug -pscomputername chi-dc04

#>