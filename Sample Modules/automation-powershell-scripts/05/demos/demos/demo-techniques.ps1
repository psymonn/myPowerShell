
$a = 1..10
$a.count
$a -is [array]
$a | Get-Member
$a
$a[0]

cls

$a | foreach-object { $_ *2 }
#writes to the pipeline
$a | foreach-object { $_ *2 } | measure-object -sum
#but not Foreach
foreach ($number in $a) { $number * 2}
foreach ($number in $a) { $number * 2} | measure-object -sum
#although you could do this
$sum = 0
foreach ($number in $a) { $sum+= $number * 2 }
$sum
cls

#objects 
#some processes don't have a StartTime value

get-process | where starttime | 
select Name,ID,@{Name='Run';Expression={(Get-Date)-$_.starttime}} |
sort Run -Descending | Select -first 5

get-process | where starttime | foreach {
    [pscustomobject]@{
        Name=$_.Name
        ID=$_.Id
        Run=((Get-Date)-$_.StartTime)
    }
} | Sort-object Run -descending | Select -first 5


ise c:\scripts\getdiskhistory.ps1