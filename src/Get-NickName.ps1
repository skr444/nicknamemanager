function Get-NickName {
    <#
        .SYNOPSIS
        [Internal] Gets the path associated to the specified nick name.

        .DESCRIPTION
        See .SYNOPSIS

        .PARAMETER NickNames
        Nick name entries containing the path to retrieve.

        .PARAMETER Nick
        Nick name alias for which to retrieve the associated path.

        .OUTPUTS
        Returns the path for the specified nick name when available, otherwise null.
    #>

    [CmdletBinding()]
    [OutputType([string])]
    param (
        [hashtable]
        [Parameter(Mandatory = $true)]
        $NickNames,

        [string]
        [Parameter(Mandatory = $true)]
        [Alias("N")]
        $Nick
    )

    try {
        if ($NickNames.Count -eq 0) {
            Write-Verbose "No entries present."
            return ""
        }

        foreach($item in $NickNames.GetEnumerator()) {
            $hits = @(@($item.Value.Split(';')) -like $Nick)
            if($hits.Count -eq 1) {
                Write-Verbose "We have a winner: '$Nick' resolved to: '$($item.Key)'"
                return $item.Key
            }
        }

        Write-Warning "The requested nick name '$Nick' was not found."
    } catch {
        Write-Warning "Failed to get nick name. Reason: $($_.Exception.Message)"
    }

    return ""
}
