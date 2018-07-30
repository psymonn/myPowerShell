#requires -version 4.0

Configuration CoreDSC {
Param(
[Parameter(Position=0,Mandatory)]
[ValidateNotNullorEmpty()][string[]]$Computername)

Node $Computername {

    WindowsFeature Backup {
        Name = "Windows-Server-Backup"        Ensure = "Present"    }          
    Service RemoteRegistry {
        Name="RemoteRegistry"
        StartUpType="Automatic"    }        
    Environment Office {        Name="Office"
        Value="Chicago"
        Ensure="present"
    }
    File Work {
        Type = "Directory"        Ensure = "Present"
        DestinationPath = "C:\Work"
    } 
    File Scripts {
        Type = "Directory"
        Ensure = "Present"        DestinationPath = "C:\Scripts"
    } 
    File Reports {
        Type = "Directory"
        Ensure = "Present"
        DestinationPath = "C:\Reports"    } 
} #node
} #close configuration

<#
1. load the configuration by running this script   . c:\scripts\coredsc.ps1   
    verify configuration is ready           get-command -CommandType Configuration2. Create the mof by invoking the configuration and specifying the nodes
   CoreDSC chi-core01,chi-fp02,chi-fp01 
   Make sure you are in the right directory or specify OutputPath
3. Use Start-DSCConfiguration
   start-dscconfiguration -path c:\scripts\CoreDSC#>