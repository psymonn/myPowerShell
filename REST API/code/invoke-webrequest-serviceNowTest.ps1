<#
.Synopsis
Formats status messages and either writes them out to a local file, or pushes them to a record in ServiceNow.  
.DESCRIPTION
The function of this cmdlet is to create formatted status messages that can either be written to a local log file, or to a record in ServiceNow.
The messages created by this cmdlet are comprised of the time/date when the cmdlet is called, the "type" (set by the MessageType parameter), and a
message passed in via the Message parameter.

 There are two Parameter Sets defined for this cmdlet:
1."Log Locally", which takes the formatted status message and writes it out to the file specified in the LogFile parameter. If the file does not exist, it will be created.
2. "Log to SNow", which creates a web request to update a specified record in SNow.
3. Upload Log", uploads a specified file to a record in SNow.    
.EXAMPLE
   New-StatusMessage -MessageType Status -Message "test" -AuthInfo $base64AuthInfo -Uri https://dev53019.service-now.com/api/now/table/rm_task/7a140fb1370f1700b6f67e5004990edf
.EXAMPLE
   New-StatusMessage -MessageType Error -Message "Error" -LogFile C:\Temp\log.log
.EXAMPLE
   New-StatusMessage -AttachmentUri "https://dev53019.service-now.com/api/now/attachment/file?table_name=rm_task&table_sys_id=7a140fb1370f1700b6f67e5004990edf" -LogFile C:\temp\log.log -AuthInfo $base64AuthInfo 
.PARAMETER MessageType
The MessageType parameter accepts one of three valid options: Error, Warning, or Status. This is placed as a part of the prefix on the string in the Message parameter.
.PARAMETER Message
The actual status message. A prefix containing the time/date and message type is added to this.
.PARAMETER LogFile
Designates a file to write status messages to. If the file does not exist it will be created.
.PARAMETER Uri
Designates a ServiceNow record to write to. This must point to a valid Sys ID for a record in SNOW.    
.PARAMETER AuthInfo
Credentials for ServiceNow passed in as a Base64 string. Can be generated using "[Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $pass)))"
.PARAMETER Method
The REST method invoked through the request. This is currently limited to "put" and "post", with "put" being set as the default.
.PARAMETER Field
This designates the field on the ServiceNow record to update. Currently, this will default to "work_notes"
.PARAMETER AttachmentUri
Designates the URI to use to attach a file to an object in ServiceNow. This will generally be used to upload full verbose logs into relevant tickets. 
#>
Function New-StatusMessage
{
    [CmdletBinding(DefaultParameterSetName = "Log Locally")]
    Param(
        [Parameter(Mandatory = $True, ParameterSetName = "Log Locally")]
        [Parameter(Mandatory = $True, ParameterSetName = "Log to SNow")]
        [ValidateSet("Error","Warning","Status")]
        [String]$MessageType,
        [Parameter(Mandatory = $True, ParameterSetName = "Log Locally")]
        [Parameter(Mandatory = $True, ParameterSetName = "Log to SNow")]
        [String]$Message,
        [Parameter(Mandatory=$false, ParameterSetName = "Log Locally")]
        [Parameter(Mandatory=$true,ParameterSetName = "Upload Log")]
        [ValidateNotNullOrEmpty()]
        [String]$LogFile = $Script:LogFile,
        [Parameter(Mandatory=$True, ParameterSetName = "Log to SNow")]
        [ValidateNotNullOrEmpty()]
        [String]$Uri,
        [Parameter(Mandatory=$True, ParameterSetName = "Log to SNow")]
        [Parameter(Mandatory=$True, ParameterSetName = "Upload Log")]
        [String]$AuthInfo,
        [Parameter(Mandatory=$False, ParameterSetName = "Log to SNow")]
        [ValidateSet("put","post")]
        [String]$Method = "put",

        [Parameter(Mandatory=$False, ParameterSetName = "Log to SNow")]
        [String]$Field = "work_notes",
        

        [Parameter(Mandatory=$True,ParameterSetName = "Upload Log")]
        [ValidateNotNullOrEmpty()]
        [String]$AttachmentUri


    )
    Begin
    {
        If(($PSCmdlet.ParameterSetName -eq "Log to SNow") -or ($PSCmdlet.ParameterSetName -eq "Log Locally"))
        {
            $Date = Get-Date -Format g
            #Format Message
            Switch($MessageType)
            {
                'Error' 
                {
                    $FormattedMessage = "$($Date)  [Error]: $($Message)"
                    Write-Host -ForegroundColor Red $FormattedMessage
                }
                'Warning' 
                {
                    $FormattedMessage = "$($Date) [Warning]: $($Message)"
                    Write-Host -ForegroundColor Yellow $FormattedMessage
                        
                }
                'Status' 
                {
                    $FormattedMessage = "$($Date) [Status]: $($Message)"
                    Write-Host -ForegroundColor Green $FormattedMessage
                }
            }
        }
    }
    Process
    {
        If($PSCmdlet.ParameterSetName -eq "Log Locally")
        {
            If(Test-Path $LogFile)
            {
                Add-Content -Value $FormattedMessage -Path $LogFile
            }
            Else
            {
                Try
                {
                    New-Item $LogFile -ItemType File -ErrorAction Stop | Out-Null
                    Add-Content -Value $FormattedMessage -Path $LogFile
                }
                Catch [System.UnauthorizedAccessException],[System.IO.DirectoryNotFoundException] 
                {
                    <# The process cannot write to the location specified. This is either because the context invoking it does not have permission, 
                    or the path doesn't exist. Either way, the log output will be redirected to C:\Windows\Temp #>

                    $NewFilePath = "C:\Windows\Temp\$($LogFile.Split("\")[-1])"
                    
                    If(Test-Path $NewFilePath)
                    {
                        Add-Content -Value $FormattedMessage -Path $NewFilePath
                    }
                    Else
                    {
                        try
                        {
                            New-Item $NewFilePath -ItemType File -ErrorAction Stop | Out-Null
                            Add-Content -Value $FormattedMessage -Path $NewFilePath
                        }
                        Catch
                        {
                            $PSCmdlet.ThrowTerminatingError($PSItem)
                        }
                        #Set Logfile location to new value at the script scope level
                        $Script:LogFile = $NewFilePath
                    }
                         
                }
                Catch
                {
                    $PSCmdlet.ThrowTerminatingError($PSItem)
                }        
            }           
        }
        ElseIf(($PSCmdlet.ParameterSetName -eq "Log to SNow") -or ($PSCmdlet.ParameterSetName -eq "Upload Log"))
        {
            # Create Header
            $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
            $headers.Add('Authorization',('Basic {0}' -f $AuthInfo))
            $headers.Add('Accept','application/json')
            $headers.Add('Content-Type','application/json')

            If($PSCmdlet.ParameterSetName -eq "Log to SNow")
            {
                #Create JSON object
                #$Body = @{$Field = $FormattedMessage} | ConvertTo-Json
                #$Body = @{Message='me';Field='qwerty'} | ConvertTo-Json
                $Body = "{ 'Message':3661515, 'Field':'test', work_notes: 'test work_notes'}"
                write-host "body message: $Body"

                $RestSplat = @{
                    Headers = $headers
                    Method = 'PUT'
                    Uri = $Uri
                    Body = $Body
                }
            }
            Else
            {
                $AttachmentUri = "$($AttachmentUri)&file_name=$($LogFile.split("\")[-1])"
                $Body = "{ 'Message':3661515, 'Field':'test'}"
                write-host "body message: $Body"

                $RestSplat = @{
                    Headers = $headers
                    Method = "POST"
                    Uri = $AttachmentUri
                   # InFile = $LogFile
                    ContentType = "text/plain"
                    Body = $Body
                }
            }
            Try
            {
                Invoke-WebRequest @RestSplat -ErrorAction Stop
            }
            Catch [System.Net.WebException]
            {
                If($PSItem.Exception -like "*(407)*") #407 = Proxy Authentication Required
                {
                    Invoke-WebRequest @RestSplat -Proxy "https://dev52858.service-now.com:8080" -ProxyUseDefaultCredentials #Default DRN proxy service
                }
                Else
                {
                    $PSCmdlet.ThrowTerminatingError($PSItem)
                }
            }
            Catch
            {
                $PSCmdlet.ThrowTerminatingError($PSItem)
            }
        }     
    }
    End
    {
    }

} 


New-StatusMessage -MessageType Status -Message "testCase3" -AuthInfo c2ltb24ubmd1eWVuNF9wcml2Ok5ndXlAbjU0NzY3Nw== -Uri https://dev52858.service-now.com/api/now/table/rm_task/7a7fc8ff4f4123001c6ff82ca310c701

[Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "user", "password")))
c2ltb24ubmd1eWVuNF9wcml2Ok5ndXlAbjU0NzY3Nw==



New-StatusMessage -AttachmentUri "https://dev52858.service-now.com/api/now/attachment/file?table_name=u_test_results&table_sys_id=391fb67b4fd123001c6ff82ca310c7c0" -LogFile "F:\GitHub\Source\ProjectSamples\Plaster New Project\TemplateProject\ProjectTemplateGenerate3\artifacts\TestResults2.xml" -AuthInfo c2ltb24ubmd1eWVuNF9wcml2Ok5ndXlAbjU0NzY3Nw== 
New-StatusMessage -AttachmentUri "https://dev52858.service-now.com/api/now/attachment/file?table_name=u_test_results&table_sys_id=09321bf74f1523001c6ff82ca310c7f0" -LogFile "F:\GitHub\Source\ProjectSamples\Plaster New Project\TemplateProject\ProjectTemplateGenerate3\artifacts\TestResults4.xml" -AuthInfo c2ltb24ubmd1eWVuNF9wcml2Ok5ndXlAbjU0NzY3Nw== 


New-StatusMessage -MessageType Status -Message "test result message" -AuthInfo c2ltb24ubmd1eWVuNF9wcml2Ok5ndXlAbjU0NzY3Nw== -Uri https://dev52858.service-now.com/api/now/table/u_test_results/09321bf74f1523001c6ff82ca310c7f0

u_test_results.list
u_test_results.form

--------------------------------------------------
Jenkins:
New-StatusMessage -MessageType Status -Message "testCase3" -AuthInfo YWRtaW46Wm5yb3A1NDc2Nzc= -Uri "http://localhost:8080/api/json?pretty=true"