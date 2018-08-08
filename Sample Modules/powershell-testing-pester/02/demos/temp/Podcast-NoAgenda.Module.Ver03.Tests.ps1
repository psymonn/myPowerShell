$here = Split-Path -Parent $MyInvocation.MyCommand.Path

$module = 'Podcast-NoAgenda'

Describe "$module Module Tests"  {

    It "has the root module $module.psm1" {
      "$here\$module.psm1" | Should Exist
    }

    It "has the a manifest file of $module.psm1" {
      "$here\$module.psd1" | Should Exist
      "$here\$module.psd1" | Should Contain "$module.psm1"
    }
        
}


