BeforeAll {
    . (($PSCommandPath | Split-Path -Parent).Replace('tests', 'src') | Join-Path -ChildPath "Confirm-UniqueValues.ps1")
    . (($PSCommandPath | Split-Path -Parent).Replace('tests', 'src') | Join-Path -ChildPath "Confirm-ValidAliases.ps1")
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1').Replace('tests', 'src')
}

Describe "Confirm-ValidNickNames" {
    Context "Data is unique" {
        It "Returns true" {
            $data = @{
                "C:\Users\{user}" = "ud;udata;userdata"
                "C:\ProgramData" = "pd;pdata;programdata"
                "C:\Program Files" = "pf64;pfiles64;programfiles64"
                "C:\Program Files (x86)" = "pf;pfiles;programfiles"
                "D:\repos" = "r;repos"
                "D:\playground" = "pg;playground"
            }

            $result = Confirm-ValidNickNames -NickNames $data
            $result | Should -Be $true
        }
    }

    Context "Nick names have duplicates" {
        It "Returns false" {
            $data = @{
                "C:\Users\{user}" = "ud;udata;userdata"
                "C:\ProgramData" = "pd;pdata;programdata"
                "C:\Program Files" = "pf64;pfiles64;programfiles64"
                "C:\Program Files (x86)" = "pf;pfiles;programfiles"
                "D:\repos" = "r;pd;repos"
                "D:\playground" = "pg;playground"
            }

            $result = Confirm-ValidNickNames -NickNames $data
            $result | Should -Be $false
        }
    }
}
