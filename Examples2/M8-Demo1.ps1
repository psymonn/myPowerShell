#demo implicit remoting

#region the problem

#needs to use different credentials for DBA access
$s = new-pssession -ComputerName chi-sql01 -Credential globomantics\administrator

#OR USE REMOTE TAB IN THE ISE

Invoke-Command { Invoke-sqlcmd "EXEC sp_helpdb @dbname= 'OperationsManager'" } -session $s
Invoke-Command { 
#hashtable of parameters to splat to Backup-SQLDatabase
$sqlParams = @{
Path = "SQLSERVER:\SQL\chi-sql01\default\databases"
Database = "OperationsManager"
BackupFile = "d:\backup\OpsManager.bak"
passthru = $True
}
Backup-SqlDatabase @sqlparams 
} -session $s

remove-pssession $s

cls
    
#endregion


#region Setting Up implicit remoting

#create PSSession
$sess = New-PSSession -ComputerName chi-sql01 -Credential globomantics\administrator

#import the module you want
Invoke-Command -scriptblock {import-module SQLPS -DisableNameChecking } -Session $sess

#export the session and commands
#this only needs to be done once
help Export-PSSession

cls

#only needs a few commands
invoke-command { get-command -Module sqlps } -session $sess
$commands = "Invoke-SQLCMD","Backup-SQLDatabase","Restore-SQLDatabase"

Export-PSSession -Session $sess -OutputModule SQLTools -Module SQLPS -CommandName $commands -Force

Remove-PSSession $sess

Get-PSSession

cls

#endregion


#region using implicit remoting

#Import Module
import-module SQLTools
get-command -module SQLTools

#connection created the first time a command is run
invoke-sqlcmd "EXEC sp_helpdb @dbname= 'OperationsManager'" 

Get-PSSession

$q = 'SELECT sqlserver_start_time AS StartTime FROM sys.dm_os_sys_info'
Invoke-Sqlcmd $q -database master
Invoke-Sqlcmd $q -database master | 
select StartTime,@{Name="Uptime";Expression={(Get-Date) - $_.starttime}},PSComputername

#paths are relative to remote server
$sqlParams = @{
Path = "SQLSERVER:\SQL\chi-sql01\default\databases"
Database = "OperationsManager"
BackupFile = "d:\backup\OpsManager.bak"
passthru = $True
}

Backup-SqlDatabase @sqlParams

#removing
remove-module sqltools
Get-pssession

cls

#if you need to avoid conflicts
import-module sqltools -Prefix My -DisableNameChecking
get-command -module sqltools

Invoke-MySqlcmd "Select @@version AS Version,@@ServerName AS Name"

remove-module SQLtools

cls

#endregion
