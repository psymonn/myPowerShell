#    Demo 3-2a
#    Run workflow remotely

#    Define the workflow
Workflow Get-BiosWFR
     {
         Get-CimInstance Win32_Bios
      }

#    And now, invoke the workflow

Get-BiosWFR –PSComputer DESKTOP-N5523PQ
