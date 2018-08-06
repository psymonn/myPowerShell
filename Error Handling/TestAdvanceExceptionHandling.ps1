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
        Write-Host ("{0,$indent}{1}" -f '' , $e.GetType().FullName) -ForegroundColor yellow

        $indent +=2
        $e = $e.InnerException
    }
}


try{

[System.IO.File]::ReadAllText( '\\test\no\filefound.log')

}catch
{
    Write-Output "Ran into an issue: $($PSItem.ToString())"
    Write-Output "Ran into an issue: $PSItem"
    $PSItem.InvocationInfo | Format-List *
    $PSItem.ScriptStackTrace
    $PSItem.Exception.Message
    $PSItem.Exception.InnerExceptionMessage
    Show-ExceptionType -Exception $_.Exception
}


Function Do-Something {

    param(
        [String] $path
        
    
    )

    if ($path -eq ""){

        #throw "Could not find: $path"
        #throw [System.IO.FileNotFoundException] "Could not find: $path"
        #throw [System.IO.FileNotFoundException]::new()
        #throw [System.IO.FileNotFoundException]::new("Could not find path: $path")

        # with normal message
       # Write-Error -Message "Could not find path: $path" -Exception ([System.IO.FileNotFoundException]::new()) -ErrorAction Stop

        # With message inside new exception
        #Write-Error -Exception ([System.IO.FileNotFoundException]::new("Could not find path: $path")) -ErrorAction Stop

        throw [System.IO.FileNotFoundException]::new("Could not find file", 'c:\path')
    }


}


try{

        try{
            Do-Something -Path $path
        }
        catch [System.IO.FileNotFoundException]
        {        
            Write-Output "Could not find $path"
             $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
             $error[0].GetType()
             $error.Count
             $error[0].ErrorDetails
             $error[0].InvocationInfo  
             $error[0].Exception
              $error[0].Exception.GetType().FullName
             $error[0].FullyQualifiedErrorId

             write-host "Caught an exception:" -ForegroundColor Red
             write-host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
             write-host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red
             Write-host $PSItem.ToString()

             Write-Output $PSItem.Exception.FileName
             Show-ExceptionType -Exception $_.Exception
             #throw [System.IO.FileNotFoundException]::new("Could not find path: $path")
             throw [System.MissingFieldException]::new('Could not access field',$PSItem.Exception)

        }
        catch [System.IO.IOException]
        {
             Write-Output "IO error with the file: $path"
             Show-ExceptionType -Exception $_.Exception
        }catch{
            Write-Output "General excpetion Could not find $path"
            write-host "Caught an exception:" -ForegroundColor Red
            write-host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
            write-host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red
            Write-host $PSItem.ToString()
            Write-Output $PSItem.Exception.FileName
            Show-ExceptionType -Exception $_.Exception
        }finally{
        }
   
   
    }catch [System.IO.DirectoryNotFoundException],[System.IO.FileNotFoundException],[System.MissingFieldException] {
        Write-Output "The path or file was not found: [$path]"
        Show-ExceptionType -Exception $_.Exception
    }catch [System.IO.IOException] {
        Write-Output "IO error with the file: [$path]"
        Show-ExceptionType -Exception $_.Exception
    }catch{
        write-host "Caught an exception:" -ForegroundColor Red
        write-host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
        write-host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red
        Write-host $PSItem.ToString()
        Show-ExceptionType -Exception $_.Exception
   }

  