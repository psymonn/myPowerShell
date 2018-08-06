#requires -version 4.0

Param(
[Parameter(Position=0,Mandatory,
HelpMessage="Enter the name of a CHICAGO server")]
[ValidatePattern("^CHI")]
[string[]]$Computername
)

#region define a DSC configuration

Configuration LocalUserAccounts {

Param(
[Parameter(Position=0,Mandatory)]
[ValidatePattern("^CHI")]
[string[]]$Computername,
[Parameter(Position=1,Mandatory)]
[PScredential]$Password
)

Node $Computername {

    User LocalAdmin {
        UserName="LocalAdmin"
        Description="Chicago Local administrator account"
        Disabled=$False
        Ensure="Present"
        Password=$Password
    }

    User Guest {
        Username="Guest"
        Disabled=$True

    }

    Group Administrators {
        GroupName="Administrators"
        DependsOn="[User]LocalAdmin"
        MembersToInclude="LocalAdmin"
    }

 } #node

} #end configuration

#endregion

#region create config data

#define a hashtable for configuration data
$ConfigData=@{AllNodes=$Null}

#node data must be an array of hashtables
$nodes=@()
foreach ($computer in $computername) {
  $nodes+=@{          NodeName = "$computer"          PSDscAllowPlainTextPassword=$true        }
} #foreach

$ConfigData.AllNodes = $nodes 
#endregion
#region create the configuration MOFs
Write-Host "Enter the credential for localadmin" -foregroundcolor greenLocalUserAccounts $computername -configurationdata $configdata -OutputPath c:\scripts\localUserAccounts
#endregion
#region push the configuration 
# Start-DscConfiguration -Path C:\scripts\LocalUserAccounts -JobName LocalAdmin
#endregion