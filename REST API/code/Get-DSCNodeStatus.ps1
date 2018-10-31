#requires -version 4.0

Function Get-DSCNodeStatus {

<#
.SYNOPSIS
Get DSC compliance status.
.DESCRIPTION
This command will query a DSC compliance server and return status information on all nodes. You can filter by computername or IP address.

Normally, compliance information is presented like this:

    TargetName         : 172.16.30.215
    ConfigurationId    : ee791d3d-a2d7-406f-8c46-066a695d896c
    ServerCheckSum     : E60C4CC1E346433CBDF1B6198BEF400F4D72D71938DBB08ACAB526A169101A03
    TargetCheckSum     : E60C4CC1E346433CBDF1B6198BEF400F4D72D71938DBB08ACAB526A169101A03
    NodeCompliant      : True
    LastComplianceTime : 2015-02-03T21:39:08.030476Z
    LastHeartbeatTime  : 2015-02-03T21:39:08.030476Z
    Dirty              : True
    StatusCode         : 0

This command reformats the output so that datetime values are [DateTime] objects, the IP address is resolved to the host name and the status code is resolved to more descriptive value.

In addition, this command will check the local configuration manager on each node to retrieve its ConfigurationModeFrequencyMins, RefreshFrequencyMins and ConfigurationMode properties. See examples.

.PARAMETER Uri
The URI to the compliance server feature.
.PARAMETER Credential
Alternate credentials for querying the compliance server as well as checking the local configuration manager on the nodes.
.PARAMETER IPaddress
Filter by IPv4 Address. A regular expression pattern is used to validate this parameter.
.PARAMETER Computername
Filter by computername. It can be a Netbios or fully qualified name although a FQDN is recommended. This parameter has aliases of CN and Host.

.EXAMPLE
PS C:\> Get-DSCNodeStatus

IPAddress          : 172.16.30.13
NodeName           : chi-core01.globomantics.local
ConfigurationId    : 15c70bc6-8778-436c-b4f5-dcf3403621bc
ServerCheckSum     : 6668B4481FEDBC41D024337B9E04E2F1C8D5A6296B67658F20C9BDCC5B661007
TargetCheckSum     : 6668B4481FEDBC41D024337B9E04E2F1C8D5A6296B67658F20C9BDCC5B661007
NodeCompliant      : True
Mode               : ApplyAndMonitor
ConfigFreq         : 15
RefreshFreq        : 30
LastComplianceTime : 2/6/2015 2:48:49 PM
LastHeartBeatTime  : 2/6/2015 2:48:49 PM
Dirty              : True
StatusCode         : 0
Status             : Configuration was applied successfully
...

IPAddress          : 172.16.30.215
NodeName           : chi-test01.globomantics.local
ConfigurationId    : 5cd9b956-415e-473d-9991-f1148a4062e4
ServerCheckSum     : 1EA2E3B617F2C9199FD5CB4C164ABE81F2F84386260F66E9ED698A95E6D434A9
TargetCheckSum     : 1EA2E3B617F2C9199FD5CB4C164ABE81F2F84386260F66E9ED698A95E6D434A9
NodeCompliant      : True
Mode               : ApplyAndMonitor
ConfigFreq         : 15
RefreshFreq        : 30
LastComplianceTime : 2/6/2015 2:47:48 PM
LastHeartBeatTime  : 2/6/2015 2:47:48 PM
Dirty              : True
StatusCode         : 0
Status             : Configuration was applied successfully

Get status for all nodes.
.EXAMPLE
PS C:\> Get-DSCNodeStatus -computername chi-test01 -credential globomantics\administrator

IPAddress          : 172.16.30.215
NodeName           : chi-test01.globomantics.local
ConfigurationId    : 5cd9b956-415e-473d-9991-f1148a4062e4
ServerCheckSum     : 1EA2E3B617F2C9199FD5CB4C164ABE81F2F84386260F66E9ED698A95E6D434A9
TargetCheckSum     : 1EA2E3B617F2C9199FD5CB4C164ABE81F2F84386260F66E9ED698A95E6D434A9
NodeCompliant      : True
Mode               : ApplyAndMonitor
ConfigFreq         : 15
RefreshFreq        : 30
LastComplianceTime : 2/6/2015 2:47:48 PM
LastHeartBeatTime  : 2/6/2015 2:47:48 PM
Dirty              : True
StatusCode         : 0
Status             : Configuration was applied successfully

Get compliance information for CHI-TEST01 using alternate credentials.

.NOTES
NAME        :  Get-DSCNodeStatus
VERSION     :  1.0   
LAST UPDATED:  2/6/2015
AUTHOR      :  Jeff Hicks

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************
.LINK
Invoke-WebRequest 
ConvertFrom-JSON 
Get-DSCLocalConfigurationManager 
.INPUTS
None
.OUTPUTS
None
#>


[cmdletbinding(DefaultParameterSetName="All")]
Param (     
[Parameter(Position=0)]
[ValidateNotNullorEmpty()]
[string]$Uri = "http://chi-web02.globomantics.local:9080/PSDSCComplianceServer.svc/Status",                       
[System.Management.Automation.Credential()]$Credential = [System.Management.Automation.PSCredential]::Empty,
[Parameter(ParameterSetName="IP")]
[ValidatePattern("^(\d{1,3}(\.)?){4}$")]
[string]$IPaddress,
[Parameter(ParameterSetName="Name")]
[Alias("CN","Host")]
[string]$Computername        
)

  $ContentType = "application/json" 

  if ($Computername) {
    #resolve computername to IP
    Write-Verbose "Filtering by computername $Computername"
     Try {
        $IPAddress = (Resolve-DnsName -Name $computername -Type A -ErrorAction Stop).IpAddress
    }
    Catch {
        Write-Warning "Can't determine IP address of $Computername"
        #bail out
        Return
    }
  }
  
  if ($IPAddress) {
    #edit the uri to filter by the IPAddress
    Write-Verbose "Filtering for IP $IPAddress"
    $uri+="?`$filter=trim(TargetName) eq '$IPAddress'"
  } 

  Write-Verbose "Querying node information from pull server URI  = $Uri" 
  Write-Verbose "Querying node status in content type  = $ContentType " 
 
 Try {
    $paramHash = @{
     Uri = $Uri     Method = 'Get'     ContentType = $ContentType     Headers = @{'Accept'=$ContentType}     ErrorAction = 'Stop'    }

    if ($Credential.UserName) {
        Write-Verbose "Using alternate credentials"
        $paramHash.Add("Credential",$Credential)
    }
    else {
        Write-Verbose "Using default credentials"
        $paramhash.add("UseDefaultCredentials",$True)
    }

    Write-Verbose ($paramHash | out-string)

    $response = Invoke-WebRequest @paramHash 
     if($response.StatusCode -ne 200) {
         Write-Warning "node information was not retrieved."
         throw
     }
 } #try
 Catch {
    Write-Warning "There was a problem."
    Write-Warning $_.exception.message
    #bail out
    Break
 }
 Write-Verbose "Converting from  JSON"
 $jsonResponse = ConvertFrom-Json $response.Content

 write-verbose ($jsonResponse | out-string)

 #decode StatusCode values
 $StatusCode = @"
 0 = Configuration was applied successfully
 1 = Download Manager initialization failure
 2 = Get configuration command failure
 3 = Unexpected get configuration response from pull server
 4 = Configuration checksum file read failure
 5 = Configuration checksum validation failure
 6 = Invalid configuration file
 7 = Available modules check failure
 8 = Invalid configuration Id In meta-configuration
 9 = Invalid DownloadManager CustomData in meta-configuration
 10 = Get module command failure
 11 = Get Module Invalid Output
 12 = Module checksum file not found
 13 = Invalid module file
 14 = Module checksum validation failure
 15 = Module extraction failed
 16 = Module validation failed
 17 = Downloaded module is invalid
 18 = Configuration file not found
 19 = Multiple configuration files found
 20 = Configuration checksum file not found
 21 = Module not found
 22 = Invalid module version format
 23 = Invalid configuration Id format
 24 = Get Action command failed
 25 = Invalid checksum algorithm
 26 = Get Lcm Update command failed
 27 = Unexpected Get Lcm Update response from pull server
 28 = Invalid Refresh Mode in meta-configuration
 29 = Invalid Debug Mode in meta-configuration
"@

$hashStatusCode = ConvertFrom-StringData $StatusCode

$values = $jsonResponse.value

 foreach ($Value in $values) {
    #resolve IP to hostname
    write-Verbose "Resolving $($value.Targetname)"
    Try {
        $nodeName = (Resolve-DnsName -Name $value.TargetName -ErrorAction Stop).namehost
    }
    Catch {
        #couldn't resolve name so use IP
        $nodeName = $value.TargetName
    }

    #get LCM settings if server is online
    if (Test-Connection $nodename -quiet -count 1) {
        Try {
            write-verbose "Getting LCM settings for $nodename"
            #create a cim session
            $phash = @{
                Computername = $nodename
                ErrorAction = "Stop"
            }
            if ($Credential.username) {
                #add the credential to New-CimSession parameters
                $phash.Add("Credential",$Credential)
            }
            $cs = New-CimSession @phash
            if ($cs) {
                $lcm = Get-DscLocalConfigurationManager -CimSession $cs -ErrorAction Stop
            }
        } #Try
        Catch {
            #server probably offline 
            Write-Warning "Error retrieving local configuration manager from $nodename"
            Write-Warning $_.Exception.Message
        } #Catch

        if ($cs) {
            Remove-CimSession $cs
        }
    } #if test connection
    
    if (-Not ($lcm.PSComputerName -eq $nodeName) ){
        #server probably offline or IP address could not be resolved
        Write-Warning "Could not retrieve local configuration manager from $($value.targetName) [$nodename]"
        $lcm = [pscustomobject]@{
            ConfigurationModeFrequencyMins = -1
            RefreshFrequencyMins = -1
            ConfigurationMode = "Unknown"
        }
    } #if lcm <> computername
    
    #write custom objects to the pipeline
     Select -InputObject $value @{Name="IPAddress";Expression={$_.TargetName}},
     @{Name="NodeName";Expression={$nodename}},
     ConfigurationID,ServerCheckSum,TargetCheckSum,NodeCompliant,
     @{Name="Mode";Expression={$lcm.ConfigurationMode}},
     @{Name="ConfigFreq";Expression={$lcm.ConfigurationModeFrequencyMins}},
     @{Name="RefreshFreq";Expression={$lcm.RefreshFrequencyMins}},
     @{Name="LastComplianceTime";Expression={$_.LastComplianceTime -as [datetime]}},
     @{Name="LastHeartBeatTime";Expression={$_.LastHeartBeatTime -as [datetime]}},
     Dirty,StatusCode,
    @{Name="Status";Expression={$hashStatusCode.($_.statuscode)}}
 } #foreach value
 
} #end function