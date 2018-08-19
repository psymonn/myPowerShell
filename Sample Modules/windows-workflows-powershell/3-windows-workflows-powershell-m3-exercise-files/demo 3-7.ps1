#    Demo 3-7
#    Workflow Modules

# Import the modules
Get-Module PSWorkFlow -ListAvailable        | Import-Module
Get-Module PSWorkFlowUtility -ListAvailable | Import-Module

# What's inside?
Get-Command -Module PSWorkFlow
Get-Command -Module PSWorkFlowUtility

# Get details of PSWorkflow
Explorer $pshome\Modules\psworkflow