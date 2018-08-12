describe 'New-BusinessUser' {

	it 'creates the AD user with the appropriate attributes' {

		#region Prerequisite Checks
		$requiredOu = 'OU=CompanyUsers,DC=mylab,DC=local'
		$domainController = 'DC'

		$requiredConditions = @(
			{ -not (Test-Connection -ComputerName $domainController -Quiet -Count 1)}
		)

		@($requiredConditions).foreach({
			if (& $_) {
				Set-TestInconclusive
			} else {
				Write-Host 'Required condition met.'
			}
		})

		$prereqConditions = @(
			@{
				Label = 'Ensure the OU is created'
                Test = { Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$requiredOu'" -Server $domainController }
				Action =  { 
					$split = $requiredOu -split ','
					$path = $split[-2..-1] -join ','
					$name = $split[0] -replace 'OU='
					New-ADOrganizationalUnit -Path $path -Name $name -Server $domainController 
				}
			}
		)

		@($prereqConditions).foreach({
			if (-not (& $_.Test)) {
				Write-Host "Test condition of [$($_.Label)] not passed. Remediating..."
				& $_.Action
			} else {
				Write-Host 'Test condition passed.'
			}
		})
		#endregion

		## Typical Pester tests here

	}

	it 'creates the home folder for the AD user' {

		#region Prerequisite Checks
		$requiredFileShare = @{ 
			Name = 'HomeFolders'
			Path = 'C:\HomeFolders'
		}
		$requiredFileServer = 'MEMBERSRV1'

		$requiredConditions = @(
			{-not (Test-Connection -ComputerName $requiredFileServer -Quiet -Count 1)}
		)

		@($requiredConditions).foreach({
			if (& $_) {
				Set-TestInconclusive
			} else {
				Write-Host 'Required condition met.'
			}
		})

		$sharedSession = New-PSSession -ComputerName $requiredFileServer

		$prereqConditions = @(
			@{
				Test = { icm -Session $sharedSession -ScriptBlock { Get-SmbShare -Name $using:requiredFileShare.Name -ErrorAction Ignore }}
				Action =  { 
					icm -Session $sharedSession -ScriptBlock { 
						if (-not (Test-Path -Path $using:requiredFileShare.Path)) {
							$null = mkdir -Path $using:requiredFileShare.Path
						}
						New-SmbShare -Name $using:requiredFileShare.Name -Path $using:requiredFileShare.Path -FullAccess Everyone
					}
				}
			}
		)

		@($prereqConditions).foreach({
			if (-not (& $_.Test)) {
				Write-Host 'Test condition not passed. Remediating...'
				& $_.Action
			} else {
				Write-Host 'Test condition passed.'
			}
		})
		#endregion

		## Typical Pester tests here

		## Cleanup
		$sharedSession | Remove-PSSession

	}
}