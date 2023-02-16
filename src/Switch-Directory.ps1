function Switch-Directory {
    [Alias("Ch2", "Change2", "ChangeTo", "Sd", "Sdir")]
    <#
        .SYNOPSIS
        Provides custom short cuts for the local powershell environment. The name comes from "change to".

        .DESCRIPTION
        Resolves either a predefined alias or a path fragment and changes to that directory on success.

        .PARAMETER Nick
        Specifies the predefined path alias (nickname) to resolve and change to if it exists.

        Cannot be used with PathFragment or Timeout.

        Aliases: N

        .PARAMETER Show
        Lists the currently registered nick names. Cannot be used with other parameters.

        Aliases: S, List, L

        .PARAMETER PathFragment
        Specifies a path fragment to search for on all available drives.

        Cannot be used with Nick.

        Aliases: PF, P, Path

        .PARAMETER Timeout
        [Optional] Specifies the time after which a search operation times out for each drive. Defaults to 4 seconds.

        Cannot be used with Nick.

        Aliases: TO, T

        .PARAMETER OpenInExplorer
        [Switch] Opens the location in Windows Explorer when specified.

        Aliases: O, OIE, Explorer, OpenExplorer

        .PARAMETER Version
        Displays the script version. Cannot be used with other parameters.

        Aliases: V

        .INPUTS
        A user alias can be piped to this command. No real gain, just for funsies :-)

        .OUTPUTS
        None.
    #>

    [CmdletBinding(DefaultParameterSetName = "Nickname")]
    [CmdletBinding(DefaultParameterSetName = "ShowClassic")]
    param (
        [string]
        [Parameter(Mandatory = $true, ParameterSetName = "Nickname", Position = 0, ValueFromPipeline = $true)]
        [Alias("N")]
        $Nick,

        [switch]
        [Parameter(Mandatory = $true, ParameterSetName = "ShowClassic")]
        [Alias("S", "List", "L")]
        $Show,

        [int]
        [Parameter(Mandatory = $false, ParameterSetName = "ShowClassic")]
        [Alias("MinSpace", "Space", "MS")]
        $MinimumSpace = 8,

        [switch]
        [Parameter(Mandatory = $false, ParameterSetName = "ShowClassic")]
        [Alias("C")]
        $Compact,

        [switch]
        [Parameter(Mandatory = $false, ParameterSetName = "ShowClassic")]
        [Parameter(Mandatory = $false, ParameterSetName = "ShowFormatTable")]
        [Alias("HideHeader", "HH")]
        $HideTableHeaders,

        [switch]
        [Parameter(Mandatory = $true, ParameterSetName = "ShowFormatTable")]
        [Alias("FT")]
        $FormatTable,

        [switch]
        [Parameter(Mandatory = $false, ParameterSetName = "ShowFormatTable")]
        [Alias("Auto", "AS")]
        $AutoSize,

        [switch]
        [Parameter(Mandatory = $false, ParameterSetName = "ShowFormatTable")]
        [Alias("W")]
        $Wrap,
        
        [string]
        [Parameter(Mandatory = $true, ParameterSetName = "Relative")]
        [Alias("PF", "P", "Path")]
        $PathFragment,

        [int]
        [Parameter(Mandatory = $false, ParameterSetName = "Relative")]
        [Alias("TO", "T")]
        $Timeout = 4,

        [switch]
        [Parameter(Mandatory = $false, ParameterSetName = "Nickname")]
        [Parameter(Mandatory = $false, ParameterSetName = "Relative")]
        [Alias("O", "OW", "OIE", "Explorer", "OpenExplorer", "OpenWindow")]
        $OpenInExplorer,

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
        $nicks | Show-NickNames -MinimumSpace $MinimumSpace -Compact:$Compact -HideTableHeaders:$HideTableHeaders
        return
    }
    if ($FormatTable) {
        $nicks | Show-NickNames -FormatTable -HideTableHeaders:$HideTableHeaders -AutoSize:$AutoSize -Wrap:$Wrap
        return
    }

    if ($nicks.Count -eq 0) {
        Write-Warning "No nick name entries present."
        return
    }

    [string]$successPath = $null

    # try to resolve nickname
    if (-not [string]::IsNullOrEmpty($Nick)) {
        try {
            $pathCandidate = Get-NickName -NickNames $nicks -Nick $Nick
            if (-not [string]::IsNullOrEmpty($pathCandidate)) {
                $successPath = Get-FolderPath -Path $pathCandidate -ReplaceFunctions @(
                    (Get-UserResolver),
                    (Get-SpecialFolderResolver)
                )
            } else {
                Write-Warning "Nickname '$Nick' not found. Add nickname entry using Add-NickName cmdlet."
            }
        } catch {
            Write-Warning "Unable to resolve nickname '$Nick'. Reason: $($_.Exception.Message)"
        }
    }

    # try to resolve path fragment
    if (-not [string]::IsNullOrEmpty($PathFragment)) {
        try{
            $targetPath = ResolvePath -Fragment $PathFragment -Timeout $Timeout

            Write-Verbose "We have a winner: $targetPath"
            Write-Debug "targetPath type: $($targetPath.GetType())"

            $successPath = $targetPath.FullName
        } catch {
            Write-Warning "Unable to resolve fragment '$PathFragment'. Reason: $($_.Exception.Message)"
        }
    }

    if (-not ([string]::IsNullOrEmpty($successPath))) {
        if (Test-Path -Path $successPath -ErrorAction SilentlyContinue) {
            # switch to path
            Write-Debug "switching to $successPath"
            Set-Location -Path $successPath

            # open in explorer
            if ($OpenInExplorer) {
                Write-Debug "opening Windows Explorer at '$successPath'"
                Invoke-Item $successPath
            }
        } else {
            Write-Warning "$successPath not found!"
        }
    }
}
