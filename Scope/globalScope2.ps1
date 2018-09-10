$global:var1 = $null

function foo ($a, $b, $varName)
{
   Set-Variable -Name $varName -Value ($a + $b) -Scope Global
}

foo 1 2 var1

$global:var1

$var1