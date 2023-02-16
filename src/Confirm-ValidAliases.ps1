function Confirm-ValidAliases {
    <#
        .SYNOPSIS
        [Internal] Verifies that the $NickNames dictionary does not contain any duplicate entries across all value
        collections.
        Also checks for empty nick names and invalid characters ':'.

        .DESCRIPTION
        See .SYNOPSIS

        .PARAMETER Aliases
        Semicolon separated list of nick names for a path.

        nick1;nick2;nick3

        Invalid characters are ':' (colon). The nick names must be unique and may not contain empty values.

        .OUTPUTS
        True, if no duplicates are detected. Otherwise false.
    #>

    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [string]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        $Aliases
    )

    try {
        if ([string]::IsNullOrEmpty($Aliases)) {
            Write-Verbose "No entries present (empty string)."
            return $false
        }
    
        $nicks = @($Aliases.Split(';'))

        if ($nicks.Count -eq 0) {
            Write-Verbose "No entries present."
            return $false
        }
    
        if ($nicks -contains "") {
            Write-Warning "Aliases '$Aliases' contains empty entry."
            return $false
        }
    
        foreach ($nick in $nicks) {
            if ($nick.Contains(":"))
            {
                Write-Warning "Nickname entry '$nick' contains invalid characters: ':'."
                return $false
            }
        }
    
        if (-not (Confirm-UniqueValues -Values $nicks)) {
            Write-Warning "Aliases contain duplicate entries. All nickname values must be unique."
            return $false
        }
    } catch {
        Write-Warning "Failed to verify unique aliases. Reason: $($_.Exception.Message)"
        return $false
    }

    Write-Debug "No duplicate nick names found in '$Aliases'."
    return $true
}
