#requires -version 3.0

#demo hashtables

#creating
$e = @{Name="Jeff";Title="MVP";Computer=$env:COMPUTERNAME}
$e

#this is its own object
$e | gm

#enumerating key
$e.Keys

#referencing elements
$e.Item("computer")
$e.computer

#creating an empty hash
$f=@{}

#adding to it
$f.Add("Name","Jeff")
$f.Add("Company","Globomantics")
$f.Add("Office","Evanston")
$f

#changing an item
$f.Office
$f.Office = "Chicago"
$f

#keys must be unique
$f.add("Name","Jane")
$f.ContainsKey("name")

#removing an item
$f.Remove("name")
$f

#group-object can create a hash table
$source = get-eventlog system -newest 100 | 
group Source -AsHashTable
$source

#get a specific entry
$source.EventLog

#handle names with spaces
$source.'Service Control Manager'

#this value is an array of event log objects
$source.EventLog[0..3]
$source.EventLog[0].message

#using GetEnumerator()
$source | get-member
$source.GetEnumerator() | Get-Member

#this will fail
$source | sort Name | Select -first 5
#here's the correct approach
$source.GetEnumerator() | Sort name | select -first 5

#Or another thing you might want to try. This will fail
$source | where {$_.name -match "winlogon"}

#although,you could do this:
$source.Keys | where {$_ -match "winlogon"} | 
foreach { $source.Item($_)}

#but this is a little easier and slightly faster
$source.GetEnumerator() | where {$_.name -match "winlogon"} | 
Select -expand Value

#hash tables are unordered
$hash = @{
Name="Jeff"
Company="Globomantics"
Office="Chicago"
Computer=$env:computername
OS = (get-ciminstance win32_operatingsystem -Property Caption).caption
}

$hash

#ordered 
$hash = [ordered]@{
Name="Jeff"
Company="Globomantics"
Office="Chicago"
Computer=$env:computername
OS = (get-ciminstance win32_operatingsystem -Property Caption).caption
}

$hash

#hashtables as object properties
$os = Get-CimInstance win32_Operatingsystem
$cs = Get-CimInstance win32_computersystem

$properties = [ordered]@{
Computername = $os.CSName
MemoryMB = $cs.TotalPhysicalMemory/1mb -As [int]
LastBoot = $os.LastBootUpTime
}

New-Object -TypeName PSObject -Property $properties

#hashtables as custom objects
[pscustomobject]$properties

#a larger example
#assume computers all running PowerShell 3.0
$computers = $env:computername,"chi-dc01","chi-dc03","chi-fp01"
$data = foreach ($computer in $computers) {
    #simplified without any real error handling
    $os = Get-CimInstance win32_Operatingsystem -ComputerName $computer
    $cs = Get-CimInstance win32_computersystem -ComputerName $computer
    $cdrive = Get-CimInstance win32_logicaldisk -filter "deviceid='c:'" -ComputerName $computer
    
    [pscustomobject][ordered]@{
    Computername = $os.CSName
    OperatingSystem = $os.Caption
    Arch = $os.OSArchitecture
    MemoryMB = $cs.TotalPhysicalMemory/1mb -As [int]
    PercentFreeC = ($cdrive.freespace/$cdrive.Size)*100 -as [int]
    LastBoot = $os.LastBootUpTime
    Runtime = (get-Date) - $os.LastBootUpTime
   }
}

$data 

#or analyze the data
$data | sort runtime | select computername,runtime

