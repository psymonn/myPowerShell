$psVarx = -1

function Init {

   $psVarx = 2
   $script:psVarx = $psVarx
}
Export-ModuleMember -variable psVarx -Function init