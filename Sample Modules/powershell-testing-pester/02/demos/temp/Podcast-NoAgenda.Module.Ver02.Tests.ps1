Describe 'Podcast-NoAgenda Module Tests' {

    It 'has the root module Podcast-NoAgenda.psm1' {
      'C:\PS\Pester-course\demo\module-02\Podcast-NoAgenda\Podcast-NoAgenda.psm1' |
         Should Exist
    }

    It "has the a manifest file of Podcast-NoAgenda.psd1" {
      'C:\PS\Pester-course\demo\module-02\Podcast-NoAgenda\Podcast-NoAgenda.psd1' |
         Should Exist

      'C:\PS\Pester-course\demo\module-02\Podcast-NoAgenda\Podcast-NoAgenda.psd1' |
         Should Contain 'Podcast-NoAgenda.psm1'
    }
        
}


