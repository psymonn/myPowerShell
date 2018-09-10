#scope: 0 = current
#       1 = parent

#this gets the info from parent's scope is it can't find in local
New-Alias -Name e -Value Get-ChildItem -Scope 1

e