# Demo 3-4
# Common Workflow Parameters – From SRV1

Workflow Get-Bios 
{
    Get-CimInstance –Class Win32_Bios
}

# Use Common Workflow parameters when invoking workflow
Get-Bios –PSComputer DC1 -PSAuthentication Kerberos -Verbose