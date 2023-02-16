BeforeAll {
    . (($PSCommandPath | Split-Path -Parent).Replace('tests', 'src') | Join-Path -ChildPath "Confirm-UniqueValues.ps1")
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1').Replace('tests', 'src')
}

Describe "Confirm-ValidAliases" {
    Context "Data is unique" {
        It "Returns true" {
            Confirm-ValidAliases -Aliases "aa;bb;cc;dd;ee" | Should -Be $true
        }
    }

    Context "Data is not unique" {
        It "Returns false" {
            Confirm-ValidAliases -Aliases "aa;bb;cc;bb;ee" | Should -Be $false
        }
    }

    Context "Data contains emtpy entry" {
        It "Returns false" {
            Confirm-ValidAliases -Aliases "aa;bb;;dd;ee" | Should -Be $false
        }
        It "Returns false" {
            Confirm-ValidAliases -Aliases "aa;bb;cc;dd;" | Should -Be $false
        }
        It "Returns false" {
            Confirm-ValidAliases -Aliases ";bb;cc;dd;ee" | Should -Be $false
        }
    }
}

# https://pester-docs.netlify.app/docs/usage/modules