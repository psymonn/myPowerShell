
<# prep

cd $home
mkdir dialects
cd dialects
$n='tag','asdfx','qwert','zxcv';
0..99 | new-item -name {"$($n|get-random)-$_.txt"} -type file -value {$_}
#>

ls

<# 
    Say you're working with the list of files, and you need to reformat the names of these files.
    Instead of 'letters' 'dash' 'number', they need to be renamed to 'number' dash 'letters'.

    Perfect job for a regular expression:
#>
cls

$str = get-item *99.txt | select -expand Name;
$str
$str -match "([a-z]+)-(\d+)"
# true

#>$matches #$global:matches

# note the captures group values

$str -replace "([a-z]+)-(\d+)", "$2-$1"

# note the munged file name, what gives?

<#
    so what can we do to help cope with these foreign dialects in PowerShell?

    Well, for starters you can turn off string interpolation by using single quotes
    instead of doubles:
#>

$a = 1
"$a is 1"
'$a is 1'

$str -replace '([a-z]+)-(\d+)', '$2-$1'

<#
    or you can escape powershell entities inside of strings using the backtick (`).
    this will tell PowerShell that you want the magic characters (like $) to be
    interpreted as their regular character equivalent
#>

"`$a is 1"
$str -replace "([a-z]+)-(\d+)", "`$2-`$1"


cls

<#
    of course, regular expressions are only one example of where you'll find this
    gotcha.  PowerShell integrates many technologies, each of which may possess
    their own text idiocyncracies.

    Another great example is ADSI:
#>

[ADSI]”LDAP://localhost:389/OU=Developers/QA,DC=CodeOwls,DC=COM”

<# 
    this LDAP URL contains an invalid character - specifically the / - that 
    needs to be escaped for AD LDS to interpret it correctly

    However, it DOES NOT need to be escaped for PowerShell:
#>

[ADSI]”LDAP://localhost:389/OU=Developers`/QA,DC=CodeOwls,DC=COM”

<#
    using the backtick produces the same error because ADSI doesn't use 
    the backtick to escape LDAP URL characters; ADSI uses the 
    backwhack (\) to escape characters in LDAP URLs:
#>
[ADSI]”LDAP://localhost:389/OU=Developers\/QA,DC=CodeOwls,DC=COM”
