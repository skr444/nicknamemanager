function Add-NickName {
    <#
        .SYNOPSIS
        Adds a nick name entry to the storage file on disk.

        .DESCRIPTION
        See .SYNOPSIS

        .PARAMETER Path
        A frequently used folder path for which to add nick names.

        .PARAMETER Aliases
        Nick names for the associated path. This is a semicolon separated string as shown below.

        nick1;nick2;nick3

        Invalid characters are ':' (colon). The nick names must be unique and may not contain empty values.

        .OUTPUTS
        True, if successful. Otherwise false.
    #>

    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [string]
        [Parameter(Mandatory = $true)]
        $Path,

        [string]
        [Parameter(Mandatory = $true)]
        $Aliases
    )

    try {
        [hashtable]$nicks = Read-NickNames

        if ($nicks.Count -gt 0) {
            $entry = $nicks[$Path]
            if ($entry) {
                Write-Warning "Nick name entry already present: $Path=$entry"
                return $false
            }
        }

        $nicks.Add($Path, $Aliases)

        if ($nicks | Write-NickNames) {
            Write-Verbose "Successfully added nick name entry for path $Path with aliases $Aliases"
            return $true
        }
    } catch {
        Write-Warning "Failed to add nick name. Reason: $($_.Exception.Message)"
    }

    return $false
}
