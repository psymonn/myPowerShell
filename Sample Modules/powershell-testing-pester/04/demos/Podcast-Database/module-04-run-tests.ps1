$host.ui.RawUI.WindowTitle = 'Pester Course Module 4'


#region Load Podcast-Database --------------------------------------------------
$dbPath = 'C:\PS\Pester-course\demo\module-04\Podcast-Database'
Set-Location $dbPath

psedit "$dbPath\Podcast-Database.psm1"
psedit "$dbPath\Podcast-Database.psd1"
psedit "$dbPath\function-Test-PodcastDatabase.ps1"
psedit "$dbPath\function-New-PodcastDatabase.ps1"
psedit "$dbPath\function-Test-PodcastTable.ps1"
psedit "$dbPath\function-New-PodcastTable.ps1"
psedit "$dbPath\function-Update-PodcastTable.ps1"

psedit "$dbPath\Podcast-Database.Module.Tests.ps1"
psedit "$dbPath\function-Test-PodcastDatabase.Tests.ps1"
psedit "$dbPath\function-New-PodcastDatabase.Tests.ps1"
psedit "$dbPath\function-Test-PodcastTable.Tests.ps1"
psedit "$dbPath\function-New-PodcastTable.Tests.ps1"
psedit "$dbPath\function-Update-PodcastTable.Tests.ps1"
#endregion Load Podcast-Database


Invoke-Pester "$dbPath\Podcast-Database.Module.Tests.ps1"
Invoke-Pester "$dbPath\function-Test-PodcastDatabase.Tests.ps1"
Invoke-Pester "$dbPath\function-New-PodcastDatabase.Tests.ps1"
Invoke-Pester "$dbPath\function-Test-PodcastTable.Tests.ps1"
Invoke-Pester "$dbPath\function-New-PodcastTable.Tests.ps1" 
Invoke-Pester "$dbPath\function-Update-PodcastTable.Tests.ps1"

