$testData = @(
    @{
        Type = "no-placeholder"
        Data = @(
            "C:\ProgramData",
            "C:\Program Files",
            "C:\Program Files (x86)",
            "D:\repos",
            "D:\playground"
        )
    },
    @{
        Type = "user-placeholder"
        Data = @(
            "C:\Users\{user}",
            "C:\Users\{user}\Documents"
        )
    },
    @{
        Type = "specialfolder-placeholder"
        Data = @(
            "{MyDocuments}\WindowsPowerShell",
            "{ApplicationData}\Microsoft",
            "{Personal}\WindowsPowerShell"
        )
    }
)

BeforeAll {
    . (($PSCommandPath | Split-Path -Parent).Replace('tests', 'src') | Join-Path -ChildPath "Get-FolderPath.ps1")
    . (($PSCommandPath | Split-Path -Parent).Replace('tests', 'src') | Join-Path -ChildPath "Confirm-ValidAliases.ps1")
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1').Replace('tests', 'src')
}

Describe "Get-FolderPath" {
    # Context "Data has no placeholder" {
    #     It "Returns the correct folder path" {

    #         $result = Confirm-ValidNickNames -NickNames $data
    #         $result | Should -Be $true
    #     }
    # }

    # Context "Nick names have duplicates" {
    #     It "Returns false" {
    #         $data = @{
    #             "C:\Users\{user}" = "ud;udata;userdata"
    #             "C:\ProgramData" = "pd;pdata;programdata"
    #             "C:\Program Files" = "pf64;pfiles64;programfiles64"
    #             "C:\Program Files (x86)" = "pf;pfiles;programfiles"
    #             "D:\repos" = "r;pd;repos"
    #             "D:\playground" = "pg;playground"
    #         }

    #         $result = Confirm-ValidNickNames -NickNames $data
    #         $result | Should -Be $false
    #     }
    # }
}
