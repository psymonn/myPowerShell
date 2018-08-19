# Demo 3-5
# Workflows Using ParameterCollection

$PSParameterCollection =  @{
  PSComputerName         = 'DC1'
  PSElapsedTimeoutSec    = 5
  PSConnectionRetryCount = 6
  PSCredential           = $Cred_DC1
},
@{
  PSComputerName         = 'SQL2012';
  PSElapsedTimeoutSec    =  10
  PSConnectionRetryCount = 10
  PSCredential           = $Cred_SQL2012   }

# Define a simple workflow
Workflow Get-Bios {Get-CimInstance -Class Win32_Bios}

# Invoke it
Get-Bios -PSParameterCollection $PSParameterCollection `
         -AsJob -JobName 'Job4.3'


# setup
$Cred_DC1 = $credrk
$Cred_SQL2012= $Credrk
