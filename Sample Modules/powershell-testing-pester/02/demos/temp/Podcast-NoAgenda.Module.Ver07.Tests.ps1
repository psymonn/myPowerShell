$here = Split-Path -Parent $MyInvocation.MyCommand.Path

$module = 'Podcast-NoAgenda'

Describe "$module Module Tests"  {

  Context 'Module Setup' {
    It "has the root module $module.psm1" {
      "$here\$module.psm1" | Should Exist
    }

    It "has the a manifest file of $module.psm1" {
      "$here\$module.psd1" | Should Exist
      "$here\$module.psd1" | Should Contain "$module.psm1"
    }

    It '$module folder has functions' {
      "$here\function-*.ps1" | Should Exist
    }

    It "$module is valid PowerShell code" {
      $psFile = Get-Content -Path "$here\$module.psm1" `
                            -ErrorAction Stop
      $errors = $null
      $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
      $errors.Count | Should Be 0
    }
  }

  $functions = ('Get-NoAgenda',
                'Get-PodcastData',
                'Get-PodcastMedia',
                'Get-PodcastImage',
                'ConvertTo-PodcastHtml',
                'ConvertTo-PodcastXML',
                'Write-PodcastHtml', 
                'Write-PodcastXML'
               )

  foreach ($function in $functions)
  {
  
    Context "Test Function $function" {
      
      It "$function.ps1 should exist" {
        "$here\function-$function.ps1" | Should Exist
      }
    
    }  
  }
        
}


