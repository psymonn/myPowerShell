get-process | where starttime | 
select Name,ID,@{Name='Run';Expression={(Get-Date)-$_.starttime}} |
sort Run -Descending | Select -first 5

get-process | where starttime|gm | foreach {
    [pscustomobject]@{
        Name=$_.Name
        ID=$_.Id
        Run=((Get-Date)-$_.StartTime)
    }
} | Sort-object Run -descending | Select -first 5


$header = @"
*******************
Low Diskpace <=30%
*******************
"@

$header | Out-File @outParams
$latest | Where-Object {$_.PctFree -le 30} |
    Sort-Object -Property Computername |
    Format-Table -AutoSize |
    Out-File @outParams



