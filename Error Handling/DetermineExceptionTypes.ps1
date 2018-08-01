Function Show-ExceptionType{

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Exception]
        $Exception
    )

    $indent = 0
    $e= $Exception

    while($e) {
        Write-Host ("{0,$indent}{1}" -f '' , $e.GetType().FullName)

        $indent +=2
        $e = $e.InnerException
    }
}

try{
    $contents = [System.IO.File]::ReadAllText('C:\Does\Not\Exist.txt')
}Catch{
    Show-ExceptionType -Exception $_.Exception
}