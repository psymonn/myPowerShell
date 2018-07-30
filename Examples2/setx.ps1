
Write-host "I am running a script" -ForegroundColor Green
if ($x) {
    Write-Host "Found an existing variable with a value of $x" -ForegroundColor yellow
}
[int32]$x = Read-host "Enter a new value for X"
Write-Host "Setting `$x to $x" -ForegroundColor Green

#do something with $x
$x+$x
