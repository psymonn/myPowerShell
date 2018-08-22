$requiredOu = 'OU=CompanyUsers,DC=mylab,DC=local'
$domainController = 'DC'

$conditions = @(
	{ -not (Test-Connection -ComputerName $domainController -Quiet -Count 1)}
	{ -not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$requiredOu'" -Server $domainController)}
)

@($conditions).foreach({
	if (& $_) {
		Set-TestInconclusive
	}
})


$a = @({ -not ("a")}
       { -not ("b")}
       )

@($a).ForEach({
    if ($_) {
        write-host $_
    }
    })


