# Demo 3-1
# Running a basic PowerShell Workflow

#  Define the workflow 
Workflow Get-BiosWF
     {
         Get-CimInstance Win32_Bios
     }


#  Invoke the workflow
Get-BiosWF

#get-item function:get-bioswf
#Get-Command get-bioswf

