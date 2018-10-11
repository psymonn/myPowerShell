#.\ScriptAnalysisCustomRules.test.ps1 -path 'C:\Data\Git\ProjectTemplateTest\ProjectTemplateGenerate5\ProjectTemplateGenerate5' -CustomRulePath 'C:\Data\Git\ProjectTemplateTest\ProjectTemplateGenerate5\Tests\CustomRules.psm1'

Param (
[String]$Path,
[String]$CustomRulePath
)

Describe 'Testing PSSA Standard rule set' {
    $AnalysisResults = Invoke-ScriptAnalyzer -Path $Path

    Context 'Rules with a severity rating of "Error"' {
        $Rules = Get-ScriptAnalyzerRule -Severity Error
        Foreach($Rule in $Rules)
        {
            It "$($Rule.RuleName)" {
                If($AnalysisResults.RuleName -contains $Rule.RuleName)
                {
                    $Failed = $true
                }
                Else
                {
                    $Failed = $false
                }
                $Failed | Should -Be $false
            }
        }
    }
    Context 'Rules with a severity rating of "Warning"' {
        $Rules = Get-ScriptAnalyzerRule -Severity Warning
        Foreach($Rule in $Rules)
        {
            It "$($Rule.RuleName)" {
                If($AnalysisResults.RuleName -contains $Rule.RuleName)
                {
                    $Failed = $true
                }
                Else
                {
                    $Failed = $false
                }
                
                $Failed | Should -Be $false
            }
        }
    }
}
If(Test-Path $CustomRulePath) {
    Describe 'Testing PSSA Custom rule set' {
        $CustomRUleAnalysisResults = Invoke-ScriptAnalyzer -Path $Path -CustomRulePath $CustomRulePath
        $Rules = Get-ScriptAnalyzerRule -CustomRulePath $CustomRulePath
        Foreach($Rule in $Rules)
        {
            It "$($Rule.RuleName)" {
                If($AnalysisResults.RuleName -contains $Rule.RuleName)
                {
                    $Failed = $true
                }
                Else
                {
                    $Failed = $false
                }
                
                $Failed | Should -Be $false
            }
        }
    }
} 
