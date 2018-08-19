#    Demo 5-1
#    Define a workflow

Workflow Debug1 {
  $A = 42
  $B = Get-CimInstance –Class Win32_Bios
  $L = $B.CurrentLanguage
   InlineScript {
       $i=42
       Get-Ciminstance -class win32_computersystem
       Get-CimInstance -class win32_processor
       $Using:a
   }

  "Language: $L"
}

# Set a breakpoint
# Set-PSBreakpoint -Script '.\Demo 5-1.ps1' -Line 5

Debug1 