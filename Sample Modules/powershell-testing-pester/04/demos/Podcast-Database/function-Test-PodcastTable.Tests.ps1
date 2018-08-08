$here = Split-Path -Parent $MyInvocation.MyCommand.Path


Get-Module Podcast-Database| Remove-Module -Force
Import-Module $here\Podcast-Database.psm1 -Force

Describe 'Test-PodcastTable Tests' {

  InModuleScope Podcast-Database {

    Push-Location
    Import-Module SqlPS -DisableNameChecking
    Pop-Location

    $PodcastDatabaseName = 'PodcastSight'

    $tbl = 'dbo.Staging'
    $dbcmd = @"
      SELECT COUNT(*) AS TableExists
        FROM [INFORMATION_SCHEMA].[TABLES]
       WHERE [TABLE_SCHEMA] + '.' + [TABLE_NAME] = '$tbl'
"@

    $result = Invoke-Sqlcmd -Query $dbcmd `
                            -ServerInstance $env:COMPUTERNAME `
                            -Database $PodcastDatabaseName `
                            -SuppressProviderContextWarning 
    
    if ($($result.TableExists) -eq 0)
    { $return = $false }
    else
    { $return = $true }

    It 'dbo.Staging should be present' {
      $(Test-PodcastTable 'PodcastSight' 'dbo.Staging') | Should Be $return    
    }
    
  } # InModuleScope Podcast-Database 

}
