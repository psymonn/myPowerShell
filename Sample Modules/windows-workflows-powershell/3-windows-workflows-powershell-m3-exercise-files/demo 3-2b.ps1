#    Demo 3-2b
#    Run parts of a workflow remotely

#    Define the workflow
Workflow Get-BiosWFR
     {
         Get-CimInstance Win32_Bios  -PSComputerName DESKTOP-N5523PQ
         Get-CimInstance Win32_Bios  -PSComputerName srv2
       }
#    And now, invoke the workflow

Get-BiosWFR

Get-ChildItem Function:\Get-BiosWFR
Get-Command Get-BiosWFR
