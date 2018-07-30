#requires -version 4.0

#DSC configuration for Chicago Globomantics servers

Configuration CHIServers {

Param(
[Parameter(Position=0,Mandatory,
HelpMessage="Enter the LocalAdmin credential")]
[PScredential]$Password
)

#define a variable for all servers
$All = @('CHI-CORE01','CHI-FP01','CHI-FP02')

Node CHI-FP01 {
    WindowsFeature Backup {
        Name = "Backup-Features"        Ensure = "Present"
    } 
}

Node @('CHI-CORE01','CHI-FP02') {
    WindowsFeature Backup {
        Name = "Windows-Server-Backup"
        Ensure = "Present"
    } 
}

Node @('CHI-FP01','CHI-FP02') {
    WindowsFeature FileServices {
        Name = "File-Services"
        Ensure = "Present"
    } 

    WindowsFeature PrintServices {
        Name = "Print-Services"
        Ensure = "Present" 
   } 
}

Node $All {

    Service RemoteRegistry { 
        Name = "RemoteRegistry"        StartUpType = "Automatic"
        State = "Running"    
     }
    Environment Office {
        Name="Office"
        Value="Chicago"
        Ensure="present"
    }

    File Work {
        Type = "Directory"
        Ensure = "Present"
        DestinationPath = "C:\Work"
    } 
    
    File Scripts {
        Type = "Directory"
        Ensure = "Present"
        DestinationPath = "C:\Scripts"    } 

    File Reports {
        Type = "Directory"
        Ensure = "Present"
        DestinationPath = "C:\Reports" 
   } 

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
}
    
} #end configuration

#region How To Use

<#
1. define a hashtable for configuration data

$nodes = @(@{NodeName = "CHI-CORE01";PSDscAllowPlainTextPassword=$true},
@{NodeName = "CHI-FP01";PSDscAllowPlainTextPassword=$true},
@{NodeName = "CHI-FP02";PSDscAllowPlainTextPassword=$true}
)

$ConfigData=@{AllNodes=$nodes}

2. load the configuration into your PowerShell session
3. Run the configuration using the configuration data

chiservers -configurationdata $ConfigData -outputpath C:\Scripts\CHIServers

4. Push the desired state

start-dscconfiguration c:\scripts\chiservers

#>

#endregion
