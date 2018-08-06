function Do-Something { 
    [cmdletbinding()]
    param(
        [string]$string
    )
    process {
        try{
            try
            {
                $getFile = Get-Content \\ FileServer\HRShare\UserList.txt -ErrorAction Stop
                #$PSCmdlet.ThrowTerminatingError($PSitem)
            }
            catch
            {
                #$PSCmdlet.ThrowTerminatingError($PSitem)
                Write-host $PSItem.ToString()
                $PSCmdlet.ThrowTerminatingError(
                [System.Management.Automation.ErrorRecord]::new(
                    ([System.IO.FileNotFoundException]"Could not find $getFile"),
                    'MY.ID',
                    [System.Management.Automation.ErrorCategory]::OpenError,
                    $MyObject
                ))
            }
        }catch{
             Write-host $PSItem.ToString()
        }
    }
}

Do-Something  something