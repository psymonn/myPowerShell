$here = Split-Path -Parent $MyInvocation.MyCommand.Path

    Push-Location
    Import-Module SqlPS -DisableNameChecking
    Pop-Location



Get-Module Podcast-Database| Remove-Module -Force
Import-Module $here\Podcast-Database.psm1 -Force

Describe 'New-PodcastTable Tests' {

  InModuleScope Podcast-Database {

    <#--------------------------------------------------------------------------
      Define some helper functions
    --------------------------------------------------------------------------#>
    function testPodcastTable($testDbName, $testTableName)
    {
      # Check to see if they included a schema, if not use dbo
      if ($testTableName.Contains('.'))
      { $tbl = $testTableName }
      else
      { $tbl = "dbo.$testTableName" }
    
      $dbcmd = @"
        SELECT COUNT(*) AS TableExists
          FROM [INFORMATION_SCHEMA].[TABLES]
         WHERE [TABLE_SCHEMA] + '.' + [TABLE_NAME] = '$tbl'
"@
    
      $result = Invoke-Sqlcmd -Query $dbcmd `
                              -ServerInstance $env:COMPUTERNAME `
                              -Database $testDbName `
                              -SuppressProviderContextWarning 
     
      if ($($result.TableExists) -eq 0)
      { $return = $false }
      else
      { $return = $true }
      
      return $return

    }

    <#--------------------------------------------------------------------------
      Main Test
    --------------------------------------------------------------------------#>
    Mock Test-PodcastTable -Verifiable {
      return testPodcastTable $testDbName $testTableName     
    }


    # Select a database name for testing. 
    $testDbName = 'PodcastSight'

    # First find a table name not in the target database
    $testTableRoot = 'dbo.TestTable'
    $testTableName = ''
    for ($i = 1; $i -lt 100; $i++) 
    {
      $testTableName = $testTableRoot + $i.ToString()
      $found = testPodcastTable $testDbName $testTableName 
      
      # Once we find one that isn't there break out of the loop
      if ($found -eq $false) { break }
    
    } # for ($i = 1; $i -lt 100; $i++) 
    
    # Now test the function by attempting to create the new table
    $newTableWasCreated = New-PodcastTable -PodcastDatabaseName $testDbName `
                                           -PodcastTableName $testTableName `
                                           -Verbose

    # Validate that all mocks were called
    It 'called all verifiable mocks' {
      Assert-VerifiableMocks
    }

    # Validate our mock was used inside of New-PodcastTable instead of 
    # the Test-PodcastTable function in the module
    It 'called the Mock for Test-PodcastTable' {
      Assert-MockCalled Test-PodcastTable
    }
    
    # Now manually check to see if the new table is there
    $manualCheck = testPodcastTable $testDbName $testTableName 

    It "new table $testTableName should exist" {
      $newTableWasCreated | Should Be $manualCheck
    }

    # Cleanup after ourselves
    Invoke-Sqlcmd -Query "DROP TABLE $testTableName" `
                  -ServerInstance $env:COMPUTERNAME `
                  -Database $testDbName `
                  -SuppressProviderContextWarning 

    # Make sure it is gone
    $manualCheck = testPodcastTable $testDbName $testTableName 

    It "should have dropped test table $testTableName as part of the test cleanup" {
      $manualCheck | Should Be $false
    }

    # The next two tests are for demonstration purposes only
    It 'has a skipped test' -Skip {
      # A test that we don't normally want to run, perhaps one that is no longer
      # useful or takes a while and we just want a quick test
    }

    It 'has a pending test' -Pending {
      # some test to be developed
    }

  } # InModuleScope Podcast-Database 

}

