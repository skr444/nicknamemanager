function Show-NickNames {
    <#
        .SYNOPSIS
        [Internal] Prints the provided nick names and their associated paths to stdout.

        .DESCRIPTION
        See .SYNOPSIS
    #>

    [CmdletBinding(DefaultParameterSetName = "Classic")]
    param (
        [hashtable]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ParameterSetName = "Classic")]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ParameterSetName = "FormatTable")]
        $NickNames,

        [int]
        [Parameter(Mandatory = $false, ParameterSetName = "Classic")]
        $MinimumSpace = 8,

        [switch]
        [Parameter(Mandatory = $false, ParameterSetName = "Classic")]
        $Compact,

        [switch]
        [Parameter(Mandatory = $false, ParameterSetName = "Classic")]
        [Parameter(Mandatory = $false, ParameterSetName = "FormatTable")]
        $HideTableHeaders,

        [switch]
        [Parameter(Mandatory = $false, ParameterSetName = "FormatTable")]
        $FormatTable,

        [switch]
        [Parameter(Mandatory = $false, ParameterSetName = "FormatTable")]
        $AutoSize,

        [switch]
        [Parameter(Mandatory = $false, ParameterSetName = "FormatTable")]
        $Wrap
    )

    if ($NickNames.Count -eq 0) {
        Write-Output "No nick names available at the time."
        return
    }

    if ($FormatTable) {
        $NickNames | Format-Table `
            -HideTableHeaders:$HideTableHeaders `
            -AutoSize:$AutoSize `
            -Wrap:$Wrap

        return
    }

    Write-Output ""
    
    $aliasColWidth = ($NickNames.Values | Measure-Object -Maximum -Property Length).Maximum
    $pathColWidth = ($NickNames.Keys | Measure-Object -Maximum -Property Length).Maximum

    if (-not $HideTableHeaders) {
        Write-Output ([string]::Concat("NICKS".PadRight($aliasColWidth + $MinimumSpace, ' '), "PATH"))
        Write-Output "$('-' * ($aliasColWidth + $MinimumSpace + $pathColWidth))"
    }

    $first = $true
    foreach($item in $NickNames.GetEnumerator()) {
        if ($first) {
            $first = $false
        } else {
            if (-not $Compact) {
                Write-Output "$('-' * ($aliasColWidth + $MinimumSpace + $pathColWidth))"
            }
        }

        $nicks = @($item.Value.Split(';'))
        $aliases = "$([string]::Join(", ", $nicks))".PadRight($aliasColWidth + $MinimumSpace, ' ')
        Write-Output "${aliases}$($item.Key)"
    }

    Write-Output ""
    Write-Output ""
}
