$BaseHomeFolder = 'C:\UsersHome'
$Employees = Import-Csv -Path C:\Employees.csv | Select-Object -first 1
foreach ($Employee in $Employees) {
	$Username = "$($Employee.FirstName.SubString(0, 1))$($Employee.LastName)"
	New-Item "$BaseHomeFolder\$Username" -Type Directory
}