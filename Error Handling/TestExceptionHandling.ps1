<#
    SilentlyContinue – error messages are suppressed and execution continues.
    Stop – forces execution to stop, behaving like a terminating error.
    Continue - the default option. Errors will display and execution will continue.
    Inquire – prompt the user for input to see if we should proceed.
    Ignore – (new in v3) – the error is ignored and not logged to the error stream. Has very restricted usage scenarios.
#>

Try
{
     Write-Error -Message "Houston, we have a problem." -ErrorAction Stop
    $AuthorizedUsers = Get-Content \\ FileServer\HRShare\UserList.txt -ErrorAction Stop
   
}
Catch [System.OutOfMemoryException]
{
    Restart-Computer localhost
}
Catch
{
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
     $error[0].GetType()
     $error.Count
     $error[0].ErrorDetails
     $error[0].InvocationInfo  
     $error[0].Exception
      $error[0].Exception.GetType().FullName
     $error[0].FullyQualifiedErrorId

     write-host "Caught an exception:" -ForegroundColor Red
    write-host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
    write-host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red
    #Send-MailMessage -From ExpensesBot@MyCompany.Com -To WinAdmin@MyCompany.Com -Subject "HR File Read Failed!" -SmtpServer EXCH01.AD.MyCompany.Com -Body "We failed to read file $FailedItem. The error message was $ErrorMessage"
    robocopy.exe "C:\DirectoryDoesNotExist" "C:\NewDestination" "*.*" /R:0
    $LastExitCode
    Break
}
Finally
{
    $Time=Get-Date
    "This script made a read attempt at $Time" | out-file c:\logs\ExpensesScript.log -append
}