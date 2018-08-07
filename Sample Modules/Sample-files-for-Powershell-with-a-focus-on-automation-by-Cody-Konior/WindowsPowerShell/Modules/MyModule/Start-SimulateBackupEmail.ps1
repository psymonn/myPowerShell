<#

.SYNOPSIS
Simulates sending an email from the boss.

.DESCRIPTION
Sometimes the boss misplaces a backup and sends one of these mails. It's
almost like he has a template.

.PARAMETER RecipientEmailAddress
The address to receive the email.

.EXAMPLE
Start-SimulateBackupEmail

.NOTES
Modification History

Date        By			Description
2014-07-21  C Konior    New.

#>
function Start-SimulateBackupEmail {
    [CmdletBinding()]
    
    Param(
       $RecipientEmailAddress = "User1@corp.contoso.com"
    )

    Import-Module -Name (
        (Get-ChildItem "$($env:ProgramFiles)\Microsoft\Exchange\Web Services" "Microsoft.Exchange.WebServices.dll" -Recurse -ErrorAction:SilentlyContinue),
        (Get-ChildItem "$($env:ProgramW6432)\Microsoft\Exchange\Web Services" "Microsoft.Exchange.WebServices.dll" -Recurse -ErrorAction:SilentlyContinue) | 
            Select -ExpandProperty FullName -First 1)

    <# Start hideous hack #>
    $Provider=New-Object Microsoft.CSharp.CSharpCodeProvider
    $Compiler=$Provider.CreateCompiler()
    $Params=New-Object System.CodeDom.Compiler.CompilerParameters
    $Params.GenerateExecutable=$False
    $Params.GenerateInMemory=$True
    $Params.IncludeDebugInformation=$False
    $Params.ReferencedAssemblies.Add("System.DLL") | Out-Null

    $TASource=@'
      namespace Local.ToolkitExtensions.Net.CertificatePolicy{
        public class TrustAll : System.Net.ICertificatePolicy {
          public TrustAll() { 
          }
          public bool CheckValidationResult(System.Net.ServicePoint sp,
            System.Security.Cryptography.X509Certificates.X509Certificate cert, 
            System.Net.WebRequest req, int problem) {
            return true;
          }
        }
      }
'@ 
    $TAResults=$Provider.CompileAssemblyFromSource($Params,$TASource)
    $TAAssembly=$TAResults.CompiledAssembly

    $TrustAll=$TAAssembly.CreateInstance("Local.ToolkitExtensions.Net.CertificatePolicy.TrustAll")
    [System.Net.ServicePointManager]::CertificatePolicy=$TrustAll
    <# End hideous hack #>

    $exchangeService = New-Object Microsoft.Exchange.WebServices.Data.ExchangeService("Exchange2013")
    $exchangeService.Credentials = New-Object System.Net.NetworkCredential("bossyboss", "Pass1word$", "corp.contoso.com")
    # $exchangeService.AutodiscoverUrl("bossyboss@corp.contoso.com")
    $exchangeService.Url = "https://EX1.corp.contoso.com/EWS/Exchange.asmx"

    # Create Email Object  
    $emailMessage = New-Object Microsoft.Exchange.WebServices.Data.EmailMessage($exchangeService) 
    $emailMessage.Subject = "HELP! I've forgotten where I've put the backups!"  
    $emailMessage.Body = "Can you help me find it? I think it's on one of the servers."  
    $emailMessage.ToRecipients.Add("user1@corp.contoso.com") | Out-Null
    $emailMessage.SendAndSaveCopy()

    Write-Verbose "Simulation email sent."
}
