#create a temporary user in Active Directory
#This requires the ActiveDirectory PowerShell module from RSAT

Param(
    [Parameter(Mandatory, HelpMessage = "Enter the user name like 'Al Fredo'")]
    [String]$Name,
    [string]$Title,
    [string]$Description,
    [string]$Department
)

Write-Host "Creating temporary AD Account for $Name." -ForegroundColor Cyan
#split the name into first and last name
$first = $name.split(' ')[0]
$last = $name.split(' ')[1]

#create the samaccountname
if ($last.Length -gt 13) {
    $accountname = "$($first[0])$($last.Substring(0,13))"
}
else {
    $accountname = "$($first[0])$last"   
}
$upn = "$accountname@company.pri"

#create a password
#use these characters as the source
#no o(scar) or l(arry) characters to avoid confusing with zero and one.
$seed = "abcdefghijkmnpqrstuvwxyz0192837465)!(@*#&$^"
#get 9 random characters
$random9 = $seed.ToCharArray() | get-random -count 9
#join back to a string
$randomstring = $random9 -join ""

#this is a regular expression pattern to match on any character from a to z
[regex]$rx = "[a-z]"
#get the first matching alphabet character
$firstalpha = $rx.match($randomstring).value
#replace the first alphabet character with its upper case version
$plaintext = $randomstring.Replace($firstalpha, $firstalpha.toUpper())

#convert the password to a secure string for the New-ADUser cmdlet
$password = ConvertTo-SecureString -String $plaintext -AsPlainText -Force

#define a hashtable of parameter values to splat to New-ADUser
$new = @{
    DisplayName           = $Name
    GivenName             = $first
    Surname               = $last
    Name                  = $accountName
    samaccountname        = $accountName
    UserPrincipalName     = $upn
    enabled               = $True
    AccountExpirationDate = (Get-Date).AddDays(180).Date
    AccountPassword       = $password
    path                  = "OU=Employees,DC=company,DC=pri"
    Title                 = $Title
    Department            = $Department
    Description           = $Description
    ErrorAction           = "Stop"
}

Try {
    New-ADUser @new
    Write-Host "Created user $accountname that expires $($new.AccountExpirationDate). Password is $plaintext." -ForegroundColor Green
}
Catch {
    $wsh = new-object -com wscript.shell
    $msg = "Failed to create user $Name. $($_.exception.message)"
    #display a popup warning and force user to click ok
    $wsh.Popup($msg, -1, "New User", 0 + 48)
}
Finally {
    Write-Host "Finished $($myinvocation.MyCommand)" -ForegroundColor Cyan
}


<#
demo usage

$p = @{
    Name = "Matilda Fuzziwick" 
    Title = "Shipping Clerk" 
    Department = "Sales"
    Description = "Seasonal hire"
}
 
.\Create-newADUser.ps1 @p
 
get-aduser mfuzziwick -Properties title,department,description

#try to create the user again

#reset demo
 get-aduser mfuzziwick | remove-aduser -confirm:$false

#>