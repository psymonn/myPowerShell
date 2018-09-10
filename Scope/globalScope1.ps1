$global:var1 = $null

function ComputeNewValue ($a, $b)
{
   $a + $b
}

$global:var1 = ComputeNewValue 1 2