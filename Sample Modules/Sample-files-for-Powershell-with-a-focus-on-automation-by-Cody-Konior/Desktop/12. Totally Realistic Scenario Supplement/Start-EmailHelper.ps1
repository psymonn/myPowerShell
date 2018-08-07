<#

.SYNOPSIS
Process email from boss.

.DESCRIPTION
If the boss has misplaced his backups he sends an email and mentions
the backups in the subject. This scans all the servers for the backups,
stores the details in SQL, and emails the results back to him.

.PARAMETER ServerName
One or more server names that will be searched.

.EXAMPLE
Start-EmailHelper

.NOTES
Modification History

Date        By			Description
2014-07-21  C Konior    New.

#>
function Start-EmailHelper
{
    [CmdletBinding()] 
    Param()
    Set-StrictMode -Version Latest

    # Prepare for HTML
    Import-Module HtmlTable -Force -Verbose:$false

    # Prepare to use EWS
    Import-Module -Name (
        (Get-ChildItem "$($env:ProgramFiles)\Microsoft\Exchange\Web Services" "Microsoft.Exchange.WebServices.dll" -Recurse -ErrorAction:SilentlyContinue),
        (Get-ChildItem "$($env:ProgramW6432)\Microsoft\Exchange\Web Services" "Microsoft.Exchange.WebServices.dll" -Recurse -ErrorAction:SilentlyContinue) | 
            Select -ExpandProperty FullName -First 1)

    <# Start hideous SSL hack #>
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
    <# End hideous SSL hack #>

    # Login to Exchange
    $exchangeService = New-Object Microsoft.Exchange.WebServices.Data.ExchangeService("Exchange2013")
    $exchangeService.Credentials = [System.Net.CredentialCache]::DefaultCredentials
    # $exchangeService.AutodiscoverUrl("User1@corp.contoso.com")
    $exchangeService.Url = "https://EX1.corp.contoso.com/EWS/Exchange.asmx"

    # Subscribe to new mails
    $inboxId = New-Object Microsoft.Exchange.WebServices.Data.FolderId([Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::Inbox)  
    $inboxIdArray = New-Object Microsoft.Exchange.WebServices.Data.FolderId[] 1  
    $inboxIdArray[0] = $inboxId  
    $pullSubscription = $exchangeService.SubscribeToPullNotifications($inboxIdArray, 60, $null,
        [Microsoft.Exchange.WebServices.Data.EventType]::NewMail)  

    Write-Verbose "Triggering boss's email for testing."
    Start-SimulateBackupEmail

    # Polling loop
    try {
        do {
            $events = $pullSubscription.GetEvents();  
            if ($events.AllEvents.Count -eq 0) {
                # Don't hammer the servers
                Start-Sleep 1
            } else {
                foreach ($event in $events.AllEvents) {
                    # Fully retrieve the email
                    $emailItem = [Microsoft.Exchange.WebServices.Data.Item]::Bind($exchangeService, $event.ItemId)
                    $emailItem.Load() 
                    Write-Verbose "$($event.EventType) from $($emailItem.Sender.Name) ($($emailItem.Sender.Address)): $($emailItem.Subject)`n$($emailItem.Body.Text)"

                    if ($emailItem.Sender.Address -eq "bossyboss@corp.contoso.com" -and $emailItem.Subject -like "*backups*") {
                        Write-Verbose "Help request received."

                        # The work needs to be done here
                        $results = Search-FilesOnServers | Select-Object -Property PSComputerName, FullName, Length, CreationTime, Attributes |
                            Sort-Object CreationTime, Length, PSComputerName -Descending 

                        <# SQL Section

                        Create Table dbo.BackupSearch (
	                        BackupSearchId int identity(1,1) Constraint PK_BackupSearch Primary Key,
	                        RequestDate datetime not null,
	                        ServerName nvarchar(max) not null,
	                        FileName nvarchar(max) not null,
	                        FileSize int not null,
	                        CreationTime datetime not null,
	                        Attributes nvarchar(max) not null
                        ) #>

                        $sqlResults = Connect-SqlServer "APP1" -SelectCommand "Select Top 0 * From dbo.BackupSearch"
                        $results | %{ 
                            $sqlRow = $sqlResults.DataSet.Tables[0].NewRow()

                            $sqlRow["RequestDate"] = $emailItem.DateTimeSent
                            $sqlRow["ServerName"] = $_.PSComputerName
                            $sqlRow["FileName"] = $_.FullName
                            $sqlRow["FileSize"] = $_.Length
                            $sqlRow["CreationTime"] = $_.CreationTime
                            $sqlRow["Attributes"] = $_.Attributes
                            
                            $sqlResults.DataSet.Tables[0].Rows.Add($sqlRow)

                        }
                        $sqlResults.Adapter.Update($sqlResults.DataSet)

                        <# End SQL Section #>

                        $html = $results | New-HtmlTable -setAlternating:$false -columnStyle @{
                                Column = "Length"
                                Style = "right"
                            }, @{
                                Column = "CreationTime"
                                Style = "right"
                            } |
                            Add-HTMLTableColor CreationTime -ge (Get-Date).AddDays(-4) -AttrValue "background-color:orange;" -WholeRow

                        $html = Close-Html "$(New-HtmlHead)$html"

                        $replyItem = $emailItem.CreateReply($true)
                        $replyItem.BodyPrefix = "Hey boss, check out this list and see if it's on here.`n`n$html"
                        $replyItem.SendAndSaveCopy()
                        $emailItem.Delete("MoveToDeletedItems")

                        Write-Verbose "Help request processed."
                    } else {
                        Write-Verbose "Ignored."
                    }
                }
            }
        } while ($true)
    } catch {
        throw
    } finally { 
        $pullSubscription.Unsubscribe()
    }
}
