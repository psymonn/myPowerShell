# Set title for project
$host.ui.RawUI.WindowTitle = 'Pester Course Module 5'

$naPath = 'C:\PS\Pester-course\demo\module-05\Podcast-NoAgenda'
Set-Location $naPath

Import-Module Pester

# Integration Unit Tests
Invoke-Pester -Tag 'Unit'

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

$naPath = 'C:\PS\Pester-course\demo\completed-final-module\Podcast-NoAgenda'
