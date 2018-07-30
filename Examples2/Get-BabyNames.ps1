#requires -version 4.0

#http address to the babynames page
$uri = "https://www.ssa.gov/OACT/babynames/index.html"

#get the data
Write-Host "Getting data from $uri" -ForegroundColor green
$data = Invoke-WebRequest $uri

#get the first table
Write-Host "Parsing the name table" -ForegroundColor green
$table = $data.ParsedHtml.getElementsByTagName("table") | Select -first 1

#get the rows
$rows = $table.rows

#get table headers
write-Host "Expanding headers" -ForegroundColor green
$headers = $rows.item(0).children | select -ExpandProperty InnerText

#count number of rows
$NumOfRows = $rows | Measure-Object

#enumerate the rows (skipping the header row) and create a custom object
Write-Host "Enumerating..." -ForegroundColor green
for ($i=1;$i -lt $NumofRows.Count;$i++) {
 #define an empty hashtable
 $objHash=[ordered]@{}
 #get the child rows
 $rowdata = $rows.item($i).children | select -ExpandProperty InnerText 
 for ($j=0;$j -lt $headers.count;$j++) {
    #add each row of data to the hash table using the corresponding
    #table header value
    $objHash.Add($headers[$j],$rowdata[$j])
  } #for

  #turn the hashtable into a custom object
  [pscustomobject]$objHash
} #for

write-host "Finished." -ForegroundColor green
#end script