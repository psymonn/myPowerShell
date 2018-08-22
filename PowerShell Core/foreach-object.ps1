ForEach-Object [-MemberName] <String> [-ArgumentList <Object[]>] [-Confirm] [-InputObject <PSObject>] [-WhatIf] [<CommonParameters>]
ForEach-Object [-Process] <ScriptBlock[]> [-Begin <ScriptBlock>] [-Confirm] [-End <ScriptBlock>] [-InputObject <PSObject>] [-RemainingScripts <ScriptBlock[]>] [-WhatIf] [<CommonParameters>]

  get-childitem C:\ | foreach-object -process { $_.length / 1024 }
  get-childitem C:\ | foreach-object { $_.length / 1024 }

   $events = get-eventlog -logname system -newest 1000

   $events | foreach-object -begin {Get-Date} `
      -process {out-file -filepath event_log.txt -append -inputobject $_.message} `
      -end {get-date}


ForEach-Object $item in (get-childitem C:\) {
    $item

}

$a | foreach-object { $_ *2 }
#writes to the pipeline
$a | foreach-object { $_ *2 } | measure-object -sum


$latest = foreach ($computer in $grouped) {
    #need to report for each deviceID on each computer
    $devices = $computer.Group  | Group-Object -Property DeviceID
    $devices | foreach-object {
        $_.Group | Sort-Object Date -Descending |  Select-object -first 1
    }
}

#normally you wouldn't use Format cmdlets in a script. This is
#an exception because I want nicely formatted output in the text file.
$latest | Sort-Object -property Computername |
    Format-Table -AutoSize | Out-file @outParams

#-----------------
$CSV = "diskhistory.csv"

1..2 | Foreach-Object {
 
    $sec = Get-Random -Minimum 640 -Maximum 2560
    $date = ((Get-Date).AddDays( - ($_) * 3)).AddSeconds( - $sec)

    $servers = @(
        [pscustomobject]@{
            Computername = 'DESKTOP-N5523PQ'
            DeviceID     = 'C:'
            Size         = 500GB
            Freespace    = (Get-Random -Minimum 75GB -Maximum 400GB)
        } ,
        [pscustomobject]@{
            Computername = 'SRV2'
            DeviceID     = 'C:'
            Size         = 128GB
            Freespace    = (Get-Random -Minimum 40GB -Maximum 75GB)
        }        
    )
    #get all properties plus calculate the percentage and get a date
    $servers | Select-Object -Property *, @{Name = "PctFree"; Expression = {($_.Freespace / $_.size) * 100}},
    @{Name = "Date"; Expression = {$date}} 
} | Export-Csv -Path $csv -NoTypeInformation #-Append

1..2 | Foreach-Object { write-host "hello"}

#-----------------------

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


