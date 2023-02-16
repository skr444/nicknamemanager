<#
    .SYNOPSIS
    NickNameManager Powershell module main file.

    .DESCRIPTION
    Module entry point containing the logic that is executed when
    the module is imported into the session with Import-Module.
#>

#Requires -Version 5
Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"
#$VerbosePreference = "Continue"

. $PSScriptRoot\Shared.ps1

. $PSScriptRoot\Add-NickName.ps1
. $PSScriptRoot\Add-NickNameManagerToProfile.ps1
. $PSScriptRoot\Confirm-UniqueValues.ps1
. $PSScriptRoot\Confirm-ValidAliases.ps1
. $PSScriptRoot\Confirm-ValidNickNames.ps1
. $PSScriptRoot\ConvertFrom-HashTable.ps1
. $PSScriptRoot\ConvertTo-HashTable.ps1
. $PSScriptRoot\Get-DefaultNickNames.ps1
. $PSScriptRoot\Get-FolderPath.ps1
. $PSScriptRoot\Get-LocalDriveLetters.ps1
. $PSScriptRoot\Get-LongestCommonSubstring.ps1
. $PSScriptRoot\Get-NickName.ps1
. $PSScriptRoot\Get-SpecialFolderResolver.ps1
. $PSScriptRoot\Get-UserResolver.ps1
. $PSScriptRoot\Import-NickNames.ps1
. $PSScriptRoot\Open-Explorer.ps1
. $PSScriptRoot\Read-NickNames.ps1
. $PSScriptRoot\Remove-NickName.ps1
. $PSScriptRoot\ResolvePath.ps1
. $PSScriptRoot\Show-NickNames.ps1
. $PSScriptRoot\Switch-Directory.ps1
. $PSScriptRoot\Write-NickNames.ps1

if (-not (Test-Path -Path $NickNameStoreFullpath)) {
    New-Item -Path $DefaultNickNameStorePath -ItemType Directory -Force

    Get-DefaultNickNames | ConvertFrom-HashTable | Set-Content -Path $NickNameStoreFullpath -Force
}

$exportModuleMemberParams = @{
    Function = @(
        'Switch-Directory',
        'Open-Explorer',
        'Add-NickName',
        'Remove-NickName',
        'Import-NickNames',
        'Add-NickNameManagerToProfile'
    )
    Variable = @(
        'NickNameStoreFullpath'
    )
    Alias = "*"
}

Export-ModuleMember @exportModuleMemberParams
