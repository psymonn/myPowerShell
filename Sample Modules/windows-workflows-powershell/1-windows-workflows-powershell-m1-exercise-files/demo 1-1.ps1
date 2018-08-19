# Demo 1-1
# Workflows are defined using the Workflow statement
Workflow Foo { "Hello World" }

# A richer workflow
Workflow Get-PSHProceses {
    Get-Process *powershell* -pscomputer DESKTOP-N5523PQ
    Get-Process *powershell* -pscomputer Win10LT
}

#foo
#Get-PSHProceses
#Get-PSHProceses2