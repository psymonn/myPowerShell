Write-Host "z is $z" #always have a value in scope, e.g $z=700

#set-variable -name z -scope global -value 500
$global:z = 500 #bad practive, don't do it
$z=200

write-host "in the scrip, z is $z"

function Foo {
        write-host "in the function, z is $z"
        $script:z =300
        Write-Host "Now, in the function, z is $z"
}

Foo
Write-Host "at this point in the script, z is $z"

.\scope2.ps1 -my_z 600