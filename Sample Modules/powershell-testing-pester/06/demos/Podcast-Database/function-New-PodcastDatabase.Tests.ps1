$here = Split-Path -Parent $MyInvocation.MyCommand.Path


Get-Module Podcast-Database| Remove-Module -Force
Import-Module $here\Podcast-Database.psm1 -Force

Describe 'New-PodcastDatabase Tests' {

  InModuleScope Podcast-Database {

    Import-Module SqlPS -DisableNameChecking
      

    # First find a db name that isn't there
    $testDbRoot = 'NewPodcastDatabaseTest'
    $testDbName = ''
    
    for($i=1; $i -le 100; $i++)
    {
      $testDbName = $testDbRoot + $i.ToString()
      $dbcmd = @"
        SELECT COUNT(*) AS DbExists
          FROM [master].[sys].[databases]
         WHERE [name] = '$($testDbName)'  
"@
      $result = Invoke-Sqlcmd -Query $dbcmd `
                              -ServerInstance $env:COMPUTERNAME `
                              -Database 'master' `
                              -SuppressProviderContextWarning 
       
      if ($($result.DbExists) -eq 0)
      { break }
    
    } # for($i=1; $i -le 100; $i++)

    # Now Attempt to create the db
    New-PodcastDatabase $testDbName

    # Now see if it exsts
    $dbcmd = @"
      SELECT COUNT(*) AS DbExists
        FROM [master].[sys].[databases]
       WHERE [name] = '$($testDbName)'  
"@

    $result = Invoke-Sqlcmd -Query $dbcmd `
                            -ServerInstance $env:COMPUTERNAME `
                            -Database 'master' `
                            -SuppressProviderContextWarning 
    
    It "should have created database $testDbName" {
      $result.DbExists | Should Be 1
    }

    # Drop the created database
    $dbDrop = @"
      ALTER DATABASE $testDbName SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
      DROP DATABASE $testDbName;
"@
    $result = Invoke-Sqlcmd -Query $dbDrop `
                            -ServerInstance $env:COMPUTERNAME `
                            -Database 'master' `
                            -SuppressProviderContextWarning 

    $result = Invoke-Sqlcmd -Query $dbcmd `
                            -ServerInstance $env:COMPUTERNAME `
                            -Database 'master' `
                            -SuppressProviderContextWarning 


    It "should have dropped database $testDbName as part of the test cleanup" {
      $result.DbExists | Should Be 0
    }

  } # InModuleScope Podcast-Database 

}
