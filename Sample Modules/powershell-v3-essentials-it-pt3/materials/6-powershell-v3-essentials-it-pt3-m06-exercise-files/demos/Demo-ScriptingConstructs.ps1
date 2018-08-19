#requires -version 3.0

#scripting constructs

#region If

$x=5
if ($x -gt 1) { 
$True 
}

if ($x -gt 10) {
 $True
}
else {
 $False
}

[adsi]$admin = "WinNT://$env:computername/administrator"
$pwdAge = $admin.passwordage.Value/86400

if ($pwdAge -ge 365) {
 "Admin password must be changed NOW!"
}
elseif ($pwdAge -ge 180) {
 "Admin password is overdue for a change."
}
elseif ($pwdAge -ge 90 ) {
 "Admin password is getting ripe."
}
elseif ($pwdAge -ge 45) {
 "Admin password should be changed."
}
else {
  "Admin password ok."
}

help about_If

#endregion

#region Switch

$dept = "Accounting"
Switch ($dept) {
    "Sales" {
      Write-Host "Running Sales department configuration" -ForegroundColor Cyan
     }
    "IT" {
      Write-Host "Running IT department configuration" -ForegroundColor Cyan
     }
    "Accounting" {
      Write-Host "Running Accounting department configuration" -ForegroundColor Cyan
     }
    "Executive" {
      Write-Host "Running Executive department configuration" -ForegroundColor Cyan
     }
    Default {
      Write-Host "Running default department configuration" -ForegroundColor Cyan
     }
} #end switch

$name = "CHI-DC04"
Switch -Regex ($name) {
    "^CHI" {
     Write-Host "Running Chicago configuration" -ForegroundColor Cyan
     #break
    }
    "^NYC" {
     Write-Host "Running New York configuration" -ForegroundColor Cyan
     #break
    }
     "^SEA" {
     Write-Host "Running Seattle configuration" -ForegroundColor Cyan
     #break
    }
    "DC\d{2}$" {
     Write-Host "Running domain controller configuration" -ForegroundColor Cyan
    }
    "FP\d{2}$" {
     Write-Host "Running File & Print configuration" -ForegroundColor Cyan
    }
    "WEB\d{2}$" {
     Write-Host "Running web server configuration" -ForegroundColor Cyan
    }
    Default {
        Write-Warning "Failed to find a matching configuration"
    }
} #end switch

help about_Switch
#endregion

#region Loops

$x=1
Do {
 $x*2
 $x++
} until ($x -ge 10)

$x=10
do {
 $x
 $x--
} while ($x -ge 5)

$x=10   #$x=4
While ($x -ge 5) {
 $x
 $x--
}

help about_Do
help about_While
#endregion

#region ForEach enumerator

$services = Get-Service
foreach ($service in $services) {
 if ($service.status -eq 'running') {
   Write-Host $service.Displayname -ForegroundColor Green
 }
 elseif ($service.status -eq 'stopped') {
  Write-Host $service.Displayname -ForegroundColor Red
 }
 else {
  #service is in some other state
  Write-Host $service.Displayname -ForegroundColor Yellow
 }
} #foreach

#ForEach does not write to the pipeline
$computers = "chi-dc01","chi-dc04","chi-dc02"

#this will fail
foreach ($c in $computers) {
  Get-WmiObject win32_operatingsystem -ComputerName $c
} | Select PSComputername,Caption,Version,CSDVersion |
Export-csv c:\work\osreport.csv

#you could do this:
$r = foreach ($c in $computers) {
  Get-WmiObject win32_operatingsystem -ComputerName $c
}

$r
$r | Select PSComputername,Caption,Version,CSDVersion |
Export-csv c:\work\osreport.csv

#but for something like this, it isn't very good PowerShell
#this would be better using ForEach-Object
$computers | ForEach { gwmi win32_operatingsystem -comp $_} |
Select PSComputername,Caption,Version,CSDVersion |
Export-csv c:\work\osreport.csv

#ForEach enumerator is good when you want to do something multiple times
#or if you know in advance the set of objects to process
$r = foreach ($c in $computers) {
  Write-Host "Processing $c" -ForegroundColor Cyan
  $OS = Get-WmiObject win32_operatingsystem -ComputerName $c
  $CDrive = Get-WmiObject win32_logicaldisk -filter "deviceid='c:'" -ComputerName $c
  $NTDS = Invoke-Command { dir c:\windows\ntds\ntds.dit} -computername $c
  $hash =[ordered]@{
   Computername = $os.pscomputername
   OS = $os.caption
   Version = $os.version
   SvcPack = $os.CSDVersion
   NTDSSize = $ntds.length
   NTDSModified = $NTDS.LastWriteTime
   C_Size = $CDrive.Size
   C_Free = $CDrive.Freespace
  }
  [pscustomobject]$hash
}

$r

help about_Foreach
#endregion

#region For

#usually used for counters
#for(<starting condition>;<while condition>;<do on each loop>) { <commands>}

for ($i=0;$i -le 5;$i++) {
  $i
}

for ($i=1;$i -le 10;$i++) {
  Get-Random    #-min $i -max ($i*10)
}

#or use this technique
1..10 | foreach { Get-Random -min $_ -max ($_*10) }

help about_For
#endregion