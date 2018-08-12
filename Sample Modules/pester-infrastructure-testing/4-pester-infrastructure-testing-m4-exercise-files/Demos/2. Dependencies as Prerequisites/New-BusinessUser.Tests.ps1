describe 'New-BusinessUser' {

	it 'creates the AD user with the appropriate attributes' {

		## Check to see if all prerequisites are in place before running test
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

	}

	it 'creates the home folder for the AD user' {

		## Check to see if all prerequisites are in place before running test
		$requiredFileShare = 'HomeFolders'
		$requiredFileServer = 'MEMBERSRV1'

		$conditions = @(
			{-not (Test-Connection -ComputerName $requiredFileServer -Quiet -Count 1)}
			{-not (icm -ComputerName $requiredFileServer -ScriptBlock { Get-SmbShare -Name $using:requiredFileShare -ErrorAction Ignore })}
		)

		@($conditions).foreach({
			if (& $_) {
				Set-TestInconclusive
			}
		})
	}
}