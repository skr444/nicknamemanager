<#
    .SYNOPSIS
    Simplistic build script.

    .DESCRIPTION
    More information about Powershell repositories and how to register them for publishing,
    see https://docs.microsoft.com/en-us/powershell/module/powershellget/?view=powershell-7.2
#>

[CmdletBinding(DefaultParameterSetName = "Build")]
param (
    [string]
    [Parameter(Mandatory = $false, ParameterSetName = "Publish")]
    [Alias("R", "Repo")]
    $Repository = "PSGallery",

    [string]
    [Parameter(Mandatory = $true, ParameterSetName = "Publish")]
    [Alias("Key", "ApiKey")]
    $NugetApiKey,

    [switch]
    [Parameter(Mandatory = $false, ParameterSetName = "Publish")]
    [Alias("P")]
    $Publish
)

$VerbosePreference = "Continue"

$outputDir = "./build/NickNameManager/"

if (Test-Path -Path $outputDir) {
    Write-Verbose "Clearing $outputDir"
    Remove-Item -Path $outputDir -Recurse -Force | Out-Null
}

Write-Verbose "Creating $outputDir"
New-Item -Path $outputDir -ItemType Directory | Out-Null

Write-Verbose "Copying module scripts to $outputDir"
Copy-Item -Path ./src/* -Destination $outputDir -Recurse | Out-Null

if ($Publish) {
    Publish-Module -Path $outputDir `
        -Repository $Repository `
        -NuGetApiKey $NugetApiKey `
        -Verbose
}
