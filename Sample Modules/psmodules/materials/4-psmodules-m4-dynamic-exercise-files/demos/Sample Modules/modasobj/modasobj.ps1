Function New-Address {
    New-Module -AsCustomObject -Name Address {
        $House    = $null
        $Street   = $null
        $Town     = $null
        $County   = $null
        $Country  = $null            
        $PostCode = $null

        Export-ModuleMember -Variable *
    }
}            

Function New-Person {
    New-Module -AsCustomObject -Name Person {
        $Name       = $null
        $Address    = $null                    
        $Occupation = $Null
        $Age        = $null
        $NiNO       = $null

        Export-ModuleMember -Variable *
    }
}            
