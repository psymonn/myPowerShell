
Write-host "I am running a script" -ForegroundColor Green
if ($x) {
    Write-Host "Found an existing variable with a value of $x" -ForegroundColor yellow
}

#do something with $x
$x+$x
