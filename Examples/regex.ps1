$name = Read-Host -Prompt "Enter server name"
switch -Regex ($name){
    "DC" {Write-Host "is a domain controller"}
    "TOP" {Write-Host "my pc name"}
    "PARENT"{Write-Host "my domain controller"}
}

if ($name -match "TOP") {Write-Host "my computer name"}