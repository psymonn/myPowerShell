set-location HKLM: 
$a = join-path System *ControlSet* -resolve
HKLM:\System\ControlSet001
HKLM:\System\ControlSet002
HKLM:\System\CurrentControlSet



$a = get-service
foreach ($b in $a){
    $b.Name
}


get-service | foreach {($_.name)}

for($i=1; $i -le 10; $i++){Write-Host $i}


 $trees = @("Alder","Ash","Birch","Cedar","Chestnut","Elm")

 foreach ($tree in $trees) {
   "$tree = " + $tree.length
 }


 foreach ($num in 1,2,3,4,5) {
  if ($num -eq 2) { continue } ; $num
 }

  foreach ($file in get-ChildItem *.txt) {
    Echo $file.name
  }


  #ForEach (method)
  @(Get-Process –Name notepad).ForEach({ Stop-Process -InputObject $_; })

  $services = Get-Service r*
  $services.foreach({"$($_.Name)--$($_.status)"})

  foreach ($service in $services) {
    $service.name

  }


foreach ($number in $a) { $number * 2}
foreach ($number in $a) { $number * 2} | measure-object -sum
#although you could do this
$sum = 0
foreach ($number in $a) { $sum+= $number * 2 }
$sum
cls

#----------------------

param(
    [string[]]$Computername = $env:COMPUTERNAME
)

#path to CSV file is hard coded because I always want to use this file
$CSV = "c:\work\diskhistory.csv"

#initialize an empty array
$data = @()

#define a hashtable of parameters to splat to Get-CimInstance
$cimParams = @{
    Classname   = "Win32_LogicalDisk"
    Filter      = "drivetype = 3" 
    ErrorAction = "Stop"
}

$cimParams.Computername = "DESKTOP-N5523PQ"
$cimParams

Write-Host "Getting disk information from $Computername" -ForegroundColor Cyan
foreach ($computer in $Computername) {
    Write-Host "Getting disk information from $computer." -ForegroundColor Cyan
    #update the hashtable on the fly
    $cimParams.Computername = $Computer
    
    Try {
        $disks = Get-CimInstance @cimparams

        $data += $disks | 
            Select-Object @{Name = "Computername"; Expression = {$_.SystemName}},
        DeviceID, Size, FreeSpace,
        @{Name = "PctFree"; Expression = { ($_.FreeSpace / $_.size) * 100}},
        @{Name = "Date"; Expression = {Get-Date}}
    } #try
    Catch {
        Write-Warning "Failed to get disk data from $($computer.toUpper()). $($_.Exception.message)"
    } #catch
} #foreach


$Computername = hostname
foreach ($computer in $Computername) {
    #verify computer is online
    if (Test-Connection -ComputerName $Computer -Count 2 -Quiet) {

        #get all volumes that have a DriveLetter assigned
        Try {
            Write-Host "Getting volume data from $($computer.toUpper())" -ForegroundColor Cyan
            $volumes = Get-Volume -CimSession $computer -ErrorAction Stop | 
                Where-Object {$_.DriveLetter} | 
                Sort-Object -Property DriveLetter
        
            #create a custom object for each volume object
            foreach ($volume in $volumes) {
                [PSCustomObject]@{
                    Computername = $volume.PSComputername.ToUpper()
                    Drive        = $volume.DriveLetter
                    FileSystem   = $volume.FileSystem
                    SizeGB       = $volume.size / 1gb -as [int32]        
                    FreeGB       = [math]::Round($volume.SizeRemaining / 1gb, 2)
                    PctFree      = [math]::Round(($volume.SizeRemaining / $volume.size) * 100, 2)
                }
            } #foreach volume 
        } #Try
        Catch {
            Write-Warning "Can't get volume data from $($Computer.ToUpper()). $($_.Exception.Message)."
        }
    } #if test is ok
    else {
        Write-Warning "Can't ping $($Computer.ToUpper())."
    }
} #foreach computer