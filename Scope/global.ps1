Share global variable with different modules:

$psVarx = -1

function Init {

   $psVarx = 2
   $script:psVarx = $psVarx
}
Export-ModuleMember -variable psVarx -Function init


--------------------------------------------------------------------

set-variable -name z -scope global -value 500
$global:z = 500 #bad practive, don't do it



