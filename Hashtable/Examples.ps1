https://kevinmarquette.github.io/2016-11-06-powershell-hashtable-everything-you-wanted-to-know-about/#hashtable-as-a-collection-of-things

$ageList = @{}

$key = 'Kevin'
$value = 36
$ageList[$key] = $value

$ageList['Alex'] = 10

$ageList['Kevin']
$ageList['Alex']


$environments = @{
    Prod = 'SrvProd05'
    QA   = 'SrvQA02'
    Dev  = 'SrvDev12'
}

$env='Dev'
$server = $environments[$env]

Get hash info using array:
$environments[@('QA','DEV','Prod')]
or
$environments[('QA','DEV','Prod')]
or
$environments['QA','DEV','Prod']

$ageList | Measure-Object

$ageList.count

$ageList.values | Measure-Object -Average

$ageList.Keys | foreach-object {
    $message = '{0} is {1} years old!' -f $_, $ageList[$_]
    Write-Output $message
}

foreach($key in $ageList.keys)
{
    $message = '{0} is {1} years old' -f $key, $ageList[$key]
    Write-Output $message

     if( $key -eq 'Kevin' ) {
        $valueFound= $ageList['Kevin']
        write-host "found $valueFound"
     }
}

$ageList.GetEnumerator() | ForEach-Object{
    $message = '{0} is {1} years old!' -f $_.key, $_.value
    Write-Output $message
}


$valueFound = $null
if( $ageList.ContainsKey('Kevin') ) {    
    write-host "found $ageList.value"
     $valueFound = $ageList['Kevin']
}

write-host "the value is $valueFound"

#######



$environments.Keys.Clone() | ForEach-Object {
    $environments[$_] = 'SrvDev03'
} 

Property based access:
$ageList = @{}
$ageList.Kevin = 35
$ageList.Alex = 9

$person = @{
    name = 'Kevin'
    age  = 36
}


$person.city = 'Austin'
$person.state = 'TX'

if( $person.age ){...}
if( $person.age -ne $null ){...}
if( $person.ContainsKey('age') ){...}

$person.remove('age')

A common way to clear a hahstable is to just initalize it to an empty hashtable.:
$person = @{}
or
$person.clear()

$person = [ordered]@{
    name = 'Kevin'
    age  = 36
}

Inline hashtables:
When you are defining a hashtable on one line, you can separate the key/value pairs with a semicolon.
$person = @{ name = 'kevin'; age = 36; }


$property = @{
    name = 'totalSpaceGB'
    expression = { ($_.used + $_.free) / 1GB }
}


$drives = Get-PSDrive | Where Used 
$drives | Select-Object name, $property

$drives | Select-Object name, @{n='totalSpaceGB';e={($_.used + $_.free) / 1GB}}

Custom sort expression:
Get-ADUser | Sort-Object -Parameter @{ e={ Get-TotalSales $_.Name } }

Sort a list of Hashtables:

$data = @(
    @{name='a'}
    @{name='c'}
    @{name='e'}
    @{name='f'}
    @{name='d'}
    @{name='b'}
)

$data | Sort-Object -Property @{e={$_.name}}




"result: build: #80 Status: FAILURE duration: 141122 requestId: REQ8007 job: PSHitchHiker%20Pineline" | ConvertTo-Json

$result = @{build='#80';Status='FAILURE';duration='141122';requestId = 'REQ8007'; job='PSHitchHiker%20Pineline' } | ConvertTo-Json

function checkPipeline
{
    $result = @{build='#80';Status='FAILURE';duration='141122';requestId = 'REQ8007'; job='PSHitchHiker%20Pineline' } | ConvertTo-Json
    Write-Output  $result
}





function checkPipeline2 {

    [CmdletBinding()]
    param (
        [Parameter (Mandatory=$true,
                    ValueFromPipeline=$true, 
                    ValueFromPipelineByPropertyName=$true)]
        [Alias('Name')]
        [string[]]$ComputerName
    )
    
    begin {} 
    process {
        $ComputerName = @{results= @{build='#80';Status='FAILURE';duration='141122';requestId = 'REQ8007'; job='PSHitchHiker%20Pineline' } } | ConvertTo-Json
        Write-Output  $ComputerName
        
    } 
    end {}
}


function checkPipeline3 {

    [CmdletBinding()]
    param (
        [Parameter (Mandatory=$true)]
                    #ValueFromPipeline=$true, 
                   # ValueFromPipelineByPropertyName=$true)]
        [string[]]$ComputerName
    )
    
    begin {} 
    process {
        $ComputerName = @{results= @{build='#80';Status='FAILURE';duration='141122';requestId = 'REQ8007'; job='PSHitchHiker%20Pineline' } } | ConvertTo-Json
        Write-Output  $ComputerName
        
    } 
    end {}
}