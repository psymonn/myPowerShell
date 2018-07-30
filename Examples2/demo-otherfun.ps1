#region use VBScript-style objects
$wsh = new-object -com wscript.shell
$wsh.Popup.OverloadDefinitions
#message,time,title,button+icon
<#
"OK"                = 0
"OKCancel"          = 1
"AbortRetryIgnore"  = 2
"YesNo"             = 4
"YesNoCancel"       = 3
"RetryCancel"       = 5

"Stop"         = 16
"Question"     = 32
"Exclamation"  = 48
"Information"  = 64
#>
$wsh.Popup("Isn't this fun?",10,"PowerShell Automation",0+64)
$wsh.Popup("Failed to do something. Do you want to try again?",-1,"Script Error",4+32)

#endregion

#region use the title bar as a progress indicator
#this may not work in all hosts
$host.ui.RawUI.WindowTitle
$saved = $host.ui.RawUI.WindowTitle
"dom1","srv1","srv2","win10" | 
foreach-object {
  $host.ui.RawUI.Windowtitle = "Querying uptime from $($_.toUpper())"
  #add an artificial pause for the sake of demonstration
  start-sleep -Seconds 2
  Get-CimInstance Win32_OperatingSystem -computername $_ | 
  Select PSComputername,LastBootUpTime,
  @{Name="Uptime";Expression={(Get-Date) - $_.LastBootUpTime}}
}

$host.ui.RawUI.Windowtitle = $saved
#learn how to use Write-Progress for more complicated scenarios
cls
#endregion

#region fun with color
#this may not work on all hosts
#change only for this session
$host.ui.RawUI
$host.ui.RawUI.backgroundColor = "black"
cls

get-service | 
foreach -begin {$fg = $host.ui.RawUI.ForegroundColor} -process {
  if ($_.status -eq 'stopped') {
    $host.ui.RawUI.ForegroundColor = "red"
  }  else {
    $host.ui.RawUI.ForegroundColor = $fg
  }
  $_
}
$host.ui.RawUI.ForegroundColor = $fg
$host.ui.RawUI.BackgroundColor = "darkmagenta"
cls
#endregion

#region PSDefaultParameterValues

get-eventlog -Newest 10

$PSDefaultParameterValues.Add("get-eventlog:logname","system")
$PSDefaultParameterValues.Add("get-ciminstance:verbose",$True)

$PSDefaultParameterValues

get-eventlog -Newest 10
get-eventlog -LogName application -Newest 10

get-ciminstance Win32_NetworkAdapter

$PSDefaultParameterValues.remove("Get-CimInstance:verbose")
#or clear them all
$PSDefaultParameterValues.Clear()

#endregion