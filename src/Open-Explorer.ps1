function Open-Explorer {
    [Alias("Oe", "Ow", "OpenWindow")]
    <#
        .SYNOPSIS
        Opens the nick name in explorer.

        .DESCRIPTION
        See .SYNOPSIS

        .PARAMETER Nick
        Specifies the predefined path alias (nickname) to resolve and change to if it exists.

        Cannot be used with PathFragment or Timeout.

        Aliases: N

        .PARAMETER Show
        Lists the currently registered nick names. Cannot be used with other parameters.

        Aliases: S, List, L

        .PARAMETER Version
        Displays the script version. Cannot be used with other parameters.

        Aliases: V

        .INPUTS
        A user alias can be piped to this command. No real gain, just for funsies :-)

        .OUTPUTS
        None.
    #>

    [CmdletBinding(DefaultParameterSetName = "Nickname")]
    param (
        [string]
        [Parameter(Mandatory = $true, ParameterSetName = "Nickname", Position = 0, ValueFromPipeline = $true)]
        [Alias("N")]
        $Nick,

        [switch]
        [Parameter(Mandatory = $false, ParameterSetName = "ShowNicknames")]
        [Alias("S", "List", "L")]
        $Show,

        [switch]
        [Parameter(Mandatory = $false, ParameterSetName = "Meta")]
        [Alias("V")]
        $Version
    )

    if ($Version) {
        try {
            $scriptName = $MyInvocation.MyCommand.Name
            $vInfo = Test-ScriptFileInfo -Path (Join-Path -Path $PSScriptRoot -ChildPath $scriptName) -ErrorAction Stop
            Write-Output "$($vInfo.Version.Major).$($vInfo.Version.Minor).$($vInfo.Version.Build)"
        } catch {}
        exit 0
    }

    if ($PSBoundParameters.ContainsKey("Debug")) {
        $DebugPreference = "Continue"

        Write-Debug "Script '$PSCommandPath' called with parameters:"
        $currentParams = $MyInvocation.BoundParameters | Format-Table -AutoSize @{
            Label = "Name"
            Expression={$_.Key}
        }, @{
            Label = "Value"
            Expression={(Get-Variable -Name $_.Key -ErrorAction SilentlyContinue).Value}
        } | Out-String
        Write-Debug $currentParams
    } else {
        $DebugPreference = "SilentlyContinue"
    }

    [hashtable]$nicks = Read-NickNames

    if ($Show) {
        $nicks | Show-NickNames
        return
    }

    if ($nicks.Count -eq 0) {
        Write-Warning "No nick name entries present."
        return
    }
    
    [string]$successPath = $null

    $pathCandidate = Get-NickName -NickNames $nicks -Nick $Nick
    if (-not [string]::IsNullOrEmpty($pathCandidate)) {
        $successPath = Get-FolderPath -Path $pathCandidate -ReplaceFunctions @(
            (Get-UserResolver),
            (Get-SpecialFolderResolver)
        )
    } else {
        Write-Warning "Nickname '$Nick' not found. Add nickname entry using Add-NickName cmdlet."
    }

    if (-not ([string]::IsNullOrEmpty($successPath))) {
        Write-Debug "opening Windows Explorer at '$successPath'"
        Invoke-Item $successPath
    }
}
