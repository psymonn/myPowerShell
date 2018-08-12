SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

i:=!i ; initiate counter
`::
if ( i = 1 ) {
	Send `
(
{{} "Name": "TESTDC" {}}

)
	i++ ; count increment
}
else if ( i = 2 ) {
	Send `
(
{{} "Memory": "4GB" {}},

)
	i++ ; count increment
}
else if ( i = 3 ) {
	Send `
(
{{} "Generation": "1" {}}, 

)
	i++ ; count increment
}
else if ( i = 4 ) {
	Send `
(
{{} "SwitchName": "LabSwitch" {}}, 

)
	i++ ; count increment
}
else if ( i = 5 ) {
	Send `
(
{{} "Path": "C:\\VMs" {}}, 

)
	i++ ; count increment
}
else if ( i = 6 ) {
	Send `
(
{{} "VHD": [

)
	i++ ; count increment
}
else if ( i = 7 ) {
	Send `
(
{{} "Path": "C:\\VHDs\\TESTDC.vhdx" {}}, 
{{} "Dynamic": "True" {}}, 
{{} "AttachedToVmName": "TESTDC" {}}, 
{{} "Size": "40GB"
)
	i++ ; count increment
}
return



esc::exitApp