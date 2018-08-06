#requires -version 4.0

<#
this is a proxy version of Get-CimInstance that gets
a pre-set list of properties back. This is intended as an easy tool
for someone to run.
#>

Function Get-MyOS {

<#
insert comment based help
#>


[CmdletBinding(DefaultParameterSetName='ClassNameComputerSet')]
 param(
     [Parameter(ParameterSetName='CimInstanceSessionSet', ValueFromPipeline=$true)]
     [ValidateNotNullOrEmpty()]
     [Microsoft.Management.Infrastructure.CimSession[]]$CimSession, 

     [Parameter(ParameterSetName='ClassNameComputerSet', Position=0,ValueFromPipelineByPropertyName=$true)]
     [Alias('CN','ServerName')]
     [ValidateNotNullOrEmpty()]
     [string[]]$ComputerName = $env:computername, 

     [Alias('OT')]
     [uint32]$OperationTimeoutSec
     
     ) 
 begin
 {
     try {
         $outBuffer = $null
         if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
         {
             $PSBoundParameters['OutBuffer'] = 1
         }

         #ADD parameters
         $PSBoundParameters.Add("Namespace","Root\CimV2")
         $PSBoundParameters.Add("Classname","Win32_OperatingSystem")

         $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('CimCmdlets\Get-CimInstance', [System.Management.Automation.CommandTypes]::Cmdlet)
         
         #MODIFIED SCRIPT COMMAND
         $scriptCmd = {& $wrappedCmd @PSBoundParameters  | 
         Select-object -property @{Name="Computername";Expression={$_.CSName}},
         @{Name="FullName";Expression= { $_.Caption}},
         Version,BuildNumber,InstallDate,OSArchitecture }

         $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
         $steppablePipeline.Begin($PSCmdlet)
     } catch {
         throw
     }
 }
 
 process
 {
     try {
         $steppablePipeline.Process($_)
     } catch {
         throw
     }
 }
 
 end
 {
     try {
         $steppablePipeline.End()
     } catch {
         throw
     }
 }
 
 

} #end function Get-MyOS