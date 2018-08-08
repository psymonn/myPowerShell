$here = Split-Path -Parent $MyInvocation.MyCommand.Path

Get-Module Podcast-Database| Remove-Module -Force
Import-Module $here\Podcast-Database.psm1 -Force

Describe 'Test-PodcastDatabase Tests' {

  InModuleScope Podcast-Database {
  
    It 'should find database PodcastSight' {
      $(Test-PodcastDatabase 'PodcastSight') | Should Be $true
    }
  
    It 'should not find database Pluralsight' {
      $(Test-PodcastDatabase 'Pluralsight') | Should Be $false
    }

  }

}
