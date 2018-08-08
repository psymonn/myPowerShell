<#

#>

function Find-NonexistantDbName ()
{
  [CmdletBinding()]
  param
  (
    [parameter (Mandatory = $false) ]
    $RootDatabaseName = 'PodcastDatabaseTest'
  )
  
  # Load the SQL PS module so we can talk to the db. If SQLPS is already loaded, no harm done.
  Push-Location
  Import-Module SqlPS -DisableNameChecking
  Pop-Location

  $testDbName = '' # Initialize variable for looping
  
  $retDbName = ''  # This will hold the value to return
  
  for($i=1; $i -le 100; $i++)
  {
    $testDbName = $RootDatabaseName + $i.ToString()
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
    { 
      $retDbName = $testDbName
      break 
    }
  
  } # for($i=1; $i -le 100; $i++)
      
  # It's highly unlikely we won't be able to find a db name that doesn't exist, but just in case...
  if ($retDbName -eq '')
  {
    throw "Could not find an available database using the root of $RootDatabaseName "
  }

  return $retDbName

} # function Find-NonexistantDbName