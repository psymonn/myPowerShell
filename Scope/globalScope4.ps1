function CheckRestart([REF]$retval) { 
    # Some logic
    $retval.Value = $true 

} 

[bool]$restart = $false 

CheckRestart( [REF]$restart) 

if ( $restart ) { 
    #Restart-Computer -Force 
    write-host "hello"
}