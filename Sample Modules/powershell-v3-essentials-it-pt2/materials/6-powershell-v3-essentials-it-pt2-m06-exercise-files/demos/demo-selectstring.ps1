#requires -version 3.0

#this is actually a regular expression match
dir s:\*.ps1 | select-string "get-ciminstance"
dir s:\*.ps1 | select-string "get-ciminstance" -SimpleMatch

#list matchings files
dir s:\*.ps1 | select-string "get-ciminstance" -List

#matchinfo object
dir s:\*.ps1 | select-string "get-ciminstance" -List | Get-Member
dir s:\*.ps1 | select-string "get-ciminstance" -List | select Filename

#use regular expression patterns
get-content C:\Windows\system32\LogFiles\HTTPERR\httperr1.log |
Select-string "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" -AllMatches

#context
$r = get-content C:\windows\WindowsUpdate.log |
Select-string "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" -AllMatches -Context 2

$r
$r[-1]

