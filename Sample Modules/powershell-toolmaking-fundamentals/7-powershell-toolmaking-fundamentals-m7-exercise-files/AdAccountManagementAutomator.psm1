## New-ModuleManifest syntax to create a new manifest
## New-ModuleManifest -RequiredModules ActiveDirectory -PowerShellVersion 4.0 -Author 'Adam Bertram'
## -CompanyName 'My Company' -Description 'This module automates many tedious tasks that must be performed when
## managing Active Directory users and computers' -PowerShellHostName ConsoleHost
## -Path C:\AdAccountManagementAutomator.psd1

function New-AmaEmployeeOnboardUser {
	<#
	.SYNOPSIS
		This function is part of the Active Directory Account Management Automator tool.  It is used to perform all routine
		tasks that must be done when onboarding a new employee user account.
	.EXAMPLE
		PS> New-AmaEmployeeOnboardUser -FirstName 'adam' -MiddleInitial D -LastName Bertram -Title 'Dr. Awesome'
	
		This example creates an AD username based on company standards into a company-standard OU and adds the user
		into the company-standard main user group.
	.PARAMETER FirstName
	 	The first name of the employee
	.PARAMETER MiddleInitial
		The middle initial of the employee
	.PARAMETER LastName
		The last name of the employee
	.PARAMETER Title
		The current job title of the employee
	#>
	[CmdletBinding()]
	param (
		[string]$Firstname,
		[string]$MiddleInitial,
		[string]$LastName,
		[string]$Location = 'OU=Corporate Users',
		[string]$Title
	)
	process {
		## Not the best use of storing the password clear text
		## Google/Bing on using stored secure strings on the file system as a way to get around this
		$DefaultPassword = 'p@$$w0rd12'
		$DomainDn = (Get-AdDomain).DistinguishedName
		$DefaultGroup = 'Gigantic Corporation Inter-Intra Synergy Group'
			
		$Username = "$($FirstName.SubString(0, 1))$LastName"
		## Check if an existing user already has the first intial/last name username taken
		try {
            if (Get-AmaADUser -Username $Username) {
				## If so, check to see if the first initial/middle initial/last name is taken.
				$Username = "$($FirstName.SubString(0, 1))$MiddleInitial$LastName"
				if (Get-AmaADUser -Username $Username) {
					throw "No acceptable username schema could be created"
				}
			}
		} catch {
            Write-Error $_.Exception.Message
        }
		$NewUserParams = @{
            'UserPrincipalName' = $Username
            'Name' = $Username
            'GivenName' = $FirstName
            'Surname' = $LastName
            'Title' = $Title
            'SamAccountName' = $Username
            'AccountPassword' = (ConvertTo-SecureString $DefaultPassword -AsPlainText -Force)
            'Enabled' = $true
            'Initials' = $MiddleInitial
            'Path' = "$Location,$DomainDn"
            'ChangePasswordAtLogon' = $true
        }
			
		New-AdUser @NewUserParams
		Add-ADGroupMember $Username $DefaultGroup
        $Username
	}
}

function New-AmaEmployeeOnboardComputer {
	<#
	.SYNOPSIS
		This function is part of the Active Directory Account Management Automator tool.  It is used to perform all routine
		tasks that must be done when onboarding a new AD computer account.
	.EXAMPLE
		PS> New-AmaEmployeeOnboardComputer -FirstName 'adam' -MiddleInitial D -LastName Bertram -Title 'Dr. Awesome'
	
		This example creates an AD username based on company standards into a company-standard OU and adds the user
		into the company-standard main user group.
	.PARAMETER Computername
	 	The name of the computer to create in AD
	.PARAMETER Location
		The AD distinguishedname of the OU that the computer account will be created in
	#>
	[CmdletBinding()]
	param (
		[string]$Computername,
		[string]$Location
	)
	process {
		try {
			if (Get-AdComputer $Computername) {
				#Write-Error "The computer name '$Computername' already exists"
				throw "The computer name '$Computername' already exists"
			}
			
			$DomainDn = (Get-AdDomain).DistinguishedName
			$DefaultOuPath = "$Location,$DomainDn"
			
			New-ADComputer -Name $Computername -Path $DefaultOuPath
		} catch {
			Write-Error $_.Exception.Message
		}
	}
}

function Set-AmaAdUser {
	<#
	.SYNOPSIS
		This function is part of the Active Directory Account Management Automator tool.  It is used to modify
		one or more Active Directory attributes on a single Active Directory user account.
	.EXAMPLE
		PS> Set-AmaAdUser -Username adam -Attributes @{'givenName' = 'bob'; 'DisplayName' = 'bobby bertram'; 'Title' = 'manager'}
	
		This example changes the givenName to bob, the display name to 'bobby bertram' and the title to 'manager' for the username 'adam'
	.PARAMETER Username
	 	An Active Directory username to modify
	.PARAMETER Attributes
		A hashtable with keys as Set-AdUser parameter values and values as Set-AdUser parameter argument values
	#>
	[CmdletBinding()]
	param (
		[string]$Username,
		[hashtable]$Attributes
	)
	process {
		try {
			## Attempt to find the username
			$UserAccount = Get-AmaADUser -Username $Username
			if (!$UserAccount) {
				## If the username isn't found throw an error and exit
				#Write-Error "The username '$Username' does not exist"
				throw "The username '$Username' does not exist"
			}
			
			## The $Attributes parameter will contain only the parameters for the Set-AdUser cmdlet other than
			## Password.  If this is in $Attributes it needs to be treated differently.
			if ($Attributes.ContainsKey('Password')) {
				$UserAccount | Set-ADAccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $Attributes.Password -Force)
				## Remove the password key because we'll be passing this hashtable directly to Set-AdUser later
				$Attributes.Remove('Password')
			}
			
			$UserAccount | Set-AdUser @Attributes
		} catch {
			Write-Error $_.Exception.Message
		}
	}
}

function Get-AmaAdUser {
	<#
	.SYNOPSIS
		This is a helper function for the AdAccountManagementAutomator Powershell module.  It is used by
		various other functions in the module to find AD user objects.
	.EXAMPLE
		PS> Get-AmaAdUser -Username adam
	
		This example queries Active Directory for a user object with the identity of 'adam'
	.PARAMETER Username
	 	One or more Active Directory usernames separated by commas
	#>
	[CmdletBinding()]
	param (
		[string[]]$Username
	)
	process {
		try {
			## Build the AD filter to find all of the user objects
			$Filter = "samAccountName -eq '"
			$Filter += $Username -join "' -or samAccountName -eq '"
			$Filter += "'"
			## Attempt to find the username
			$UserAccount = Get-AdUser -Filter $Filter
			if ($UserAccount) {
				$UserAccount
			}
		} catch {
			Write-Error $_.Exception.Message
		}
	}
}

function Set-AmaAdComputer {
	<#
	.SYNOPSIS
		This function is part of the Active Directory Account Management Automator tool.  It is used to modify
		one or more Active Directory attributes on a single Active Directory computer account.
	.EXAMPLE
		PS> Set-AmaAdComputer -Computername adampc -Attributes @{'Location' = 'Phoenix'; 'Description' = 'is a little problematic'}
	
		This example changes the location to Phoenix and the description of the AD computer adampc to 'is a little problematic'
	.PARAMETER Computername
	 	An Active Directory computer account to modify
	.PARAMETER Attributes
		A hashtable with keys as Set-AdComputer parameter values and values as Set-AdComputer parameter argument values
	#>
	[CmdletBinding()]
	param (
		[string]$Computername,
		[hashtable]$Attributes
	)
	process {
		try {
			## Attempt to find the Computername
			$Computer = Get-AdComputer -Identity $Computername
			if (!$Computer) {
				## If the Computername isn't found throw an error and exit
				#Write-Error "The Computername '$Computername' does not exist"
				throw "The Computername '$Computername' does not exist"
			}
			
			## The $Attributes parameter will contain only the parameters for the Set-AdComputer cmdlet
			$Computer | Set-AdComputer @Attributes
		} catch {
			Write-Error $_.Exception.Message
		}
	}
}

Export-ModuleMember -Function New-AmaEmployeeOnboardComputer
Export-ModuleMember -Function New-AmaEmployeeOnboardUser
Export-ModuleMember -Function Set-AmaAdUser
Export-ModuleMember -Function Set-AmaAdComputer