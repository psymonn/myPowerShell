SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

i:=!i ; initiate counter
`::
if ( i = 1 ) {
	Send `
(
describe 'New-TestEnvironment' {{}

{}}
)
	i++ ; count increment
}
else if ( i = 2 ) {
	Send `
(
context 'Virtual Machine' {{}

{}}

context 'Operating System' {{}
	
{}}

context 'AD users' {{}
	
{}}

context 'AD groups' {{}
	
{}}

context 'AD OUs' {{}
	
{}}

context 'CSV file' {{}
	
{}}
)
	i++ ; count increment
}
return

esc::exitApp