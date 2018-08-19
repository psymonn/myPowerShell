# Set title for project
$host.ui.RawUI.WindowTitle = 'Pester Course Module 3'

$naPath = 'F:\STUDYING\a PLURALSIGHT Courses\POWERSHELL\powershell-testing-pester\03\demos\Podcast-NoAgenda'
Set-Location $naPath

Import-Module Pester

Invoke-Pester "$naPath\Podcast-NoAgenda.Module.Tests.ps1"

Invoke-Pester "$naPath\function-Get-PodcastData.Tests.ps1"

Invoke-Pester "$naPath\function-Get-PodcastImage.Tests.ps1" -Tag 'Unit'
Invoke-Pester "$naPath\function-Get-PodcastImage.Tests.ps1" -Tag 'Acceptance'
Invoke-Pester "$naPath\function-Get-PodcastImage.Tests.ps1" 

Invoke-Pester "$naPath\function-Get-PodcastMedia.Tests.ps1" -Tag 'Unit'
Invoke-Pester "$naPath\function-Get-PodcastMedia.Tests.ps1" -Tag 'Acceptance'
Invoke-Pester "$naPath\function-Get-PodcastMedia.Tests.ps1" 

Invoke-Pester "$naPath\function-ConvertTo-PodcastXML.Tests.ps1" 
Invoke-Pester "$naPath\function-Write-PodcastXML.Tests.ps1" 

Invoke-Pester "$naPath\function-ConvertTo-PodcastHtml.Tests.ps1" 
Invoke-Pester "$naPath\function-Write-PodcastHtml.Tests.ps1" 

Invoke-Pester "$naPath\function-Get-NoAgenda.Tests.ps1" -tag 'Unit'
Invoke-Pester "$naPath\function-Get-NoAgenda.Tests.ps1" -tag 'Acceptance'

$naPath = 'C:\PS\Pester-course\demo\completed-final-module\Podcast-NoAgenda'

