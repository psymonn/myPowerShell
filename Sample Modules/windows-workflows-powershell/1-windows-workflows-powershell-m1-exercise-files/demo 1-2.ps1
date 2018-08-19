# Demo 1-2 – using workflow syntax extensions
# Details of syntax extensions in next module in this course

# A still richer workflow
Workflow Get-PSHProceses2 {
    Parallel {
        Get-Process *powershell* -PSComputerName DESKTOP-N5523PQ	
        Get-Process *powershell* -PSComputerName Win10LT	
        Get-Process *powershell* -PSComputerName Cookham24
    }
}
