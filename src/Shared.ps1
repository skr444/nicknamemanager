<#
    .Description
    Global variables and other shared stuff.
#>

# default values for the storage file.
[string]$DefaultNickNameStoreFilename = "nicknames.txt"
[string]$DefaultNickNameStoreFolder = ".nicknames"
[string]$DefaultNickNameStorePath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile) | `
    Join-Path -ChildPath $DefaultNickNameStoreFolder
[string]$DefaultNickNameStoreFullpath = $DefaultNickNameStorePath | Join-Path -ChildPath $DefaultNickNameStoreFilename

# active storage file
[string]$NickNameStoreFullpath = $DefaultNickNameStoreFullpath
