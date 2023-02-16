BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1').Replace('tests', 'src')
}

Describe "Confirm-UniqueValues" {
    Context "Data is unique" {
        It "Returns true" {
            $data = @(
                "one",
                "two",
                "three",
                "four"
            )

            $result = Confirm-UniqueValues -Values $data
            $result | Should -Be $true
        }
    }

    Context "Data is not unique" {
        It "Returns false" {
            $data = @(
                "one",
                "two",
                "three",
                "four",
                "two"
            )

            $result = Confirm-UniqueValues -Values $data
            $result | Should -Be $false
        }
    }
}
