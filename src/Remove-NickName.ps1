function Remove-NickName {
    <#
        .SYNOPSIS
        Creates a default set of aliases for frequently used path locations.

        .DESCRIPTION
        See .SYNOPSIS

        .PARAMETER Path
        The path of the entry to remove.

        .OUTPUTS
        True, if successful. Otherwise false.
    #>

    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [string]
        [Parameter(Mandatory = $true)]
        $Path
    )
    
    try {
        [hashtable]$nicks = Read-NickNames

        if ($nicks.Count -gt 0) {
            if ($nicks.ContainsKey($Path)) {
                $nicks.Remove($Path)

                if ($nicks | Write-NickNames) {
                    Write-Verbose "Successfully removed nick name entry for path $Path."
                    return $true
                }
            } else {
                Write-Warning "No entry found for $Path"
            }
        } else {
            Write-Verbose "Got nothing to remove."
        }
    } catch {
        Write-Warning "Failed to remove nick name entry. Reason: $($_.Exception.Message)"
    }

    return $false
}
