#requires -version 5.0

#this script assumes all the other files are in the same directory 
#and your location is set to that directory

#Notice the full use of cmdlet and parameter names as well
#as my use of comments and code formatting.

#define a filename using the date
$filename = "$(Get-Date -Format "yyyyddMM")-VolumeReport.txt"

#construct a full path name using the current directory
$report = Join-Path -path . -ChildPath $filename

#verify computers.txt can be found
if (Test-Path -Path .\computers.txt) {

    #get the list of computers
    $computers = Get-Content -Path .\computers.txt

    #run the DriveReport script against the list of computers
    $data = .\DriveReport.ps1 -Computername $computers
  
    #only create the report if data is captured
    if ($data) {
        #Create a report header and save to the report file
        "Volume Report: $(Get-Date)" | Out-File -FilePath $filename
        "Run by: $($env:USERNAME)" | Out-File -FilePath $filename -append
        "**********************************" | Out-File -FilePath $filename -Append
  
        #Sort the volume data and format the results which are then
        #saved to the file. This is an exception case where using a
        #format cmdlet is acceptable.
        $data | 
            Sort-Object -Property Computername, Drive |
            Format-Table -GroupBy Computername -Property Drive, FileSystem, SizeGB, FreeGB, PctFree |
            Out-File -FilePath $report -Append

        #save missed computers to a separate text file
        $found = $data.computername | Select-Object -Unique
        $missed = $computers | Where-Object {$found -notcontains $_} 
        $missed | Out-File -filepath .\Offline.txt

        "Missed computers" |  Out-File -FilePath $filename -append
        $missed | foreach-object {$_.toUpper()} | Out-File -FilePath $filename -append

        Write-Host "Report finished. See $report." -ForegroundColor Green
    } #if $data
    else {
        Write-Warning "Failed to capture any volume information. Is DiskReport.ps1 in the same folder as this script?"
    }
}
else {
    Write-Warning "Can't find computers.txt."
}

