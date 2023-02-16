<#
    .Description
    A script for arbitrary testing.
#>

$VerbosePreference = "Continue"
$DebugPreference = "Continue"
$InformationPreference = "Continue"

. (($PSCommandPath | Split-Path -Parent).Replace('tests', 'src') | Join-Path -ChildPath "Get-NickName.ps1")
. (($PSCommandPath | Split-Path -Parent).Replace('tests', 'src') | Join-Path -ChildPath "Get-LocalDriveLetters.ps1")
. (($PSCommandPath | Split-Path -Parent).Replace('tests', 'src') | Join-Path -ChildPath "Get-FolderPath.ps1")
. (($PSCommandPath | Split-Path -Parent).Replace('tests', 'src') | Join-Path -ChildPath "Get-UserResolver.ps1")
. (($PSCommandPath | Split-Path -Parent).Replace('tests', 'src') | Join-Path -ChildPath "Get-SpecialFolderResolver.ps1")
. (($PSCommandPath | Split-Path -Parent).Replace('tests', 'src') | Join-Path -ChildPath "ConvertTo-HashTable.ps1")
. (($PSCommandPath | Split-Path -Parent).Replace('tests', 'src') | Join-Path -ChildPath "Confirm-UniqueValues.ps1")
. (($PSCommandPath | Split-Path -Parent).Replace('tests', 'src') | Join-Path -ChildPath "Confirm-ValidAliases.ps1")
. (($PSCommandPath | Split-Path -Parent).Replace('tests', 'src') | Join-Path -ChildPath "Confirm-ValidNickNames.ps1")
. (($PSCommandPath | Split-Path -Parent).Replace('tests', 'src') | Join-Path -ChildPath "Read-NickNames.ps1")
. (($PSCommandPath | Split-Path -Parent).Replace('tests', 'src') | Join-Path -ChildPath "Switch-Directory.ps1")

$NickNameStoreFullpath = "D:\repos\aaaaprojectsetup\scripts\psutils\sys\nicknames.txt"

$paths = @(
    "C:\Users\{user}",
    "C:\Users\{user}\Documents",
    "{MyDocuments}\WindowsPowerShell",
    "{ApplicationData}\Microsoft",
    "{Personal}\WindowsPowerShell",
    "C:\test\{Foo}\somefolder"
)

# $pattern = "{{{0}}}"
# [string[]]$specialFolders = @()

# foreach ($value in [System.Enum]::GetValues([System.Environment+SpecialFolder])) {
#     $specialFolders += ($pattern -f $value).ToString()
# }

# $specialFolders = $specialFolders | Select-Object -Unique | Sort-Object

# $paths[5] -imatch "^\{.+\}"
# $Matches[0]

#$resolver = Get-UserResolver
# $resolver = Get-SpecialFolderResolver
# $resolver.Invoke($paths[4])

$result = Get-FolderPath -Path $paths[3] -ReplaceFunctions @(
    (Get-UserResolver),
    (Get-SpecialFolderResolver)
)
$result

Switch-Directory -Nick psusrprof
