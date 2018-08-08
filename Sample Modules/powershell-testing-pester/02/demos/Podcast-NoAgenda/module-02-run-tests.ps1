$host.ui.RawUI.WindowTitle = 'Pester Course Module 2'

$naPath = 'C:\PS\Pester-course\demo\module-02\Podcast-NoAgenda'
Set-Location $naPath

Import-Module Pester

Invoke-Pester "$naPath\Podcast-NoAgenda.Module.Ver09.Tests.ps1"

Invoke-Pester "$naPath\function-Get-PodcastData.Tests.ps1"

Invoke-Pester "$naPath\function-Get-PodcastImage.Tests.ps1" -Tag 'Unit'
Invoke-Pester "$naPath\function-Get-PodcastImage.Tests.ps1" -Tag 'Acceptance'
Invoke-Pester "$naPath\function-Get-PodcastImage.Tests.ps1" 

Invoke-Pester "$naPath\function-Get-PodcastMedia.Tests.ps1" -Tag 'Unit'
Invoke-Pester "$naPath\function-Get-PodcastMedia.Tests.ps1" -Tag 'Acceptance'
Invoke-Pester "$naPath\function-Get-PodcastMedia.Tests.ps1" 

Invoke-Pester "$naPath\function-ConvertTo-PodcastXML.Tests.ps1" 
Invoke-Pester "$naPath\function-Write-PodcastXML.Tests.ps1" 

Invoke-Pester "$naPath\function-Get-NoAgenda.Tests.ps1" -tag 'Unit'
Invoke-Pester "$naPath\function-Get-NoAgenda.Tests.ps1" -tag 'Acceptance'











$naPath = 'C:\PS\pester-course\demo\completed-final-module\Podcast-NoAgenda'
Set-Location $naPath

Invoke-Pester "$naPath\Podcast-NoAgenda.Module.Ver01.Tests.ps1"
Invoke-Pester "$naPath\Podcast-NoAgenda.Module.Ver02.Tests.ps1"
Invoke-Pester "$naPath\Podcast-NoAgenda.Module.Ver03.Tests.ps1"
Invoke-Pester "$naPath\Podcast-NoAgenda.Module.Ver04.Tests.ps1"
Invoke-Pester "$naPath\Podcast-NoAgenda.Module.Ver05.Tests.ps1"
Invoke-Pester "$naPath\Podcast-NoAgenda.Module.Ver06.Tests.ps1"
Invoke-Pester "$naPath\Podcast-NoAgenda.Module.Ver07.Tests.ps1"
Invoke-Pester "$naPath\Podcast-NoAgenda.Module.Ver08.Tests.ps1"
Invoke-Pester "$naPath\Podcast-NoAgenda.Module.Ver09.Tests.ps1"

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

Invoke-Pester "C:\PS\Pester-course\demo\module-02\Podcast-NoAgenda\function-Get-NoAgenda.Tests.ps1" -tag 'Unit'
