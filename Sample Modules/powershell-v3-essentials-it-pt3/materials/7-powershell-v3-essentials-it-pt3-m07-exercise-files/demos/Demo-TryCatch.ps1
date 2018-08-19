#requires -version 3.0

#demo try/catch

#test with different values of the -ErrorAction parameter

$computers = "chi-dc01","chi-dc02","chi-web01",
"chi-dc03","chi-db01","chi-fp01"

#hashtable of parameters values to splat
$cimParams=@{
    Classname = "win32_logicaldisk"
    Filter = "deviceid='c:'"
    ErrorAction = "continue"
}

<#
 A command like this might still work, but doesn't handle the 
 error very well.

 Get-CimInstance @cimParams -ComputerName $computers
#>

foreach ($computer in $computers) {

    $cimParams.Computername = $computer    

    Try {
        Write-Host "Querying $computer" -ForegroundColor Cyan
        $data = Get-CimInstance @cimParams 
        $data | Select PSComputername,DeviceID,Size,Freespace,VolumeName
    }
    Catch {
        Write-Warning "Failed to get data from $computer"
        Write-Warning $_.exception
    }
    Finally {
#        Write-Host "This is optional and always runs" -ForegroundColor Green
    }

} #foreach