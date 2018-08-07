# Gross

Get-ChildItem C:\Temp | Select-Object -Property FullName, Length, CreationTime, Attributes | ConvertTo-Html | Set-Content C:\Temp\ConvertToHtml.html
&explorer C:\Temp\ConvertToHtml.html

# Much better

Import-Module HTMLTable -Force

$htmlBody = Get-ChildItem C:\Temp | Select-Object -Property FullName, Length, CreationTime, Attributes | New-HtmlTable
Close-Html "$(New-HtmlHead)$htmlBody" | Set-Content C:\Temp\HtmlTable.html
&explorer C:\Temp\HtmlTable.html

# Or even better...

$htmlBody = Get-ChildItem C:\Temp | Select-Object -Property FullName, Length, CreationTime, Attributes | 
    New-HtmlTable -setAlternating:$true -columnStyle @{
            Column = "Length"
            Style = "right"
        }, @{
            Column = "CreationTime"
            Style = "right"
        } |
Add-HTMLTableColor Attributes -like "Directory" -AttrValue "color:white;background-color:#6699FF;" -WholeRow |
Add-HTMLTableColor Length -gt 38000 -AttrValue "background-color:orange;"

Close-Html "$(New-HtmlHead)$htmlBody" | Set-Content C:\Temp\HtmlTableHighlights.html
&explorer C:\Temp\HtmlTableHighlights.html



