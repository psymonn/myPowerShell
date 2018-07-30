#requires -version 4.0

#Pluralsight PowerShell v4 New Features

#region Where

<#
$collection.Where({ expression } [, mode [, numberToReturn]])

System.Management.Automation.WhereOperatorSelectionMode = Default, First, Last, SkipUntil, Until, Split

#>

#use $_ or $psitem

(get-service).where({$_.status -eq 'running'})
(get-service).where({$_.status -eq 'running'},"last",5)

(get-process).where({$psitem.ws -gt 100MB})

(get-process | sort ws -Descending).where({$psitem.ws -gt 100MB})
(get-process | sort ws -Descending).where({$psitem.ws -gt 25MB},"first",5)

$split = (get-process | sort ws -Descending).where({$_.ws -gt 25MB},"split")                                              
$split[0].count
$split[0]
$split[1].count

(1..10).where({$_ -gt 5})
(1..10).where({$_ -gt 5},"skipuntil",2)
(1..10).where({$_ -gt 5},"until",2)

(dir S:\*.ps1).Where({$_.length -gt 25kb})
(dir S:\*.ps1).Where({$_.length -gt 25kb},"until",2)

#endregion

#region foreach
# $collection.ForEach(expression [, arguments...])

"alice","bob","carol","david" | Foreach {$_.toupper()}

("alice","bob","carol","david").Foreach({$_.toupper()})
("alice","bob","carol","david").Foreach({$_.Substring(0,1)})
("alice","bob","carol","david").Foreach({$_.Substring(0,1).ToUpper()})

(1..10).foreach({([math]::pi)*([math]::Pow($_,2))})

Add-Type -assembly System.IO.Compression.FileSystem

(dir c:\work\*.xml).Foreach({
write-Host "zipping $($_.fullname)" -ForegroundColor Green
$zip = [System.IO.Compression.ZipFile]::Open("c:\work\$($_.basename).zip","Create")
[System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip,$_.fullname,$_.name)
$zip.Dispose()
})

#zip folders that haven't changed in the last 30 days
(dir c:\work -Directory).where(
{$_.LastWriteTime -le (Get-Date).AddDays(-30)}).foreach({
$zipPath = Join-Path "C:\Zip" "$($_.name).zip"
Write-Host "Zipping $($_.fullname) to $zipPath" -ForegroundColor Green
[System.IO.Compression.ZipFile]::CreateFromDirectory($_.FullName,
$zipPath)
Get-Item $zipPath
})

#endregion

#region combos

(get-process).Where({$_.ws -ge 25MB}).foreach({$_.name.toUpper()}) | 
Select -Unique

#the old way
dir S:\ -file -Recurse | Where {$_.length -ge 500kb} | Get-Acl |
select @{Name="Path";Expression={(Resolve-Path $_.Path).Providerpath}},
@{Name="Size";Expression={ (get-item $_.path).length }},Owner

#the new way
#this is a one-line command
(dir S:\ -file -Recurse).Where({$_.length -ge 500kb}).foreach({
$size = $_.length ;
Get-Acl $_.fullname | 
select @{Name="Path";Expression={(Resolve-Path $_.Path).ProviderPath}},
@{Name="Size";Expression={$size}},Owner})

#endregion

#region performance gains

#old
measure-command {1..100000 | where {$_%2}}

#new
measure-command { (1..100000).where({$_%2})}

#old
measure-command {1..100000 | foreach {$_*2}}

#new
measure-command {(1..100000 ).Foreach({$_*2})}

$x=1000
#the old way
#this is hardly a practical example but it is
#pipeline intensive
Measure-command {
(1..$x) | foreach { get-process | where {$_.name -eq "svchost"}} 
} 

#the new way
Measure-Command {
(1..$x).foreach({(get-process).where({$_.name -eq "svchost"})})
}

Measure-Command {

dir S:\ -file -Recurse | Where {$_.length -ge 500kb} | Get-Acl |
select @{Name="Path";Expression={(Resolve-Path $_.Path).Providerpath}},
@{Name="Size";Expression={ (get-item $_.path).length }},Owner

}

#the new way
Measure-Command {

#this is a one-line command
(dir S:\ -file -Recurse).Where({$_.length -ge 500kb}).foreach({
$size = $_.length ;
Get-Acl $_.fullname | 
select @{Name="Path";Expression={(Resolve-Path $_.Path).ProviderPath}},
@{Name="Size";Expression={$size}},Owner})

}

#endregion



