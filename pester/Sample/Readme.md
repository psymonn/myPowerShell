Contains functions to create, modify and delete an SCCM boundary object. These functions are named:

Create-SCCMBoundary

Modify-SCCMBoundary

Delete-SCCMBoundary

All other functions are used internally by the above functions.

All files named "'function'.test.ps1" are the pester testing files for the corresponding function.

"SCCMTestScript.ps1" can be used to run pester tests for different functions in the repo.

The folder named "SCCMBoundaryTools" is the module folder that contains the create, modify and delete function and all the internal functions. Only the create, modify and delete functions are exported to be called by the user.
