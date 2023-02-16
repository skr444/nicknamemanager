function Confirm-ValidNickNames {
    <#
        .SYNOPSIS
        [Internal] Verifies that the $NickNames dictionary does not contain any duplicate entries across all value
        collections.
        Also checks for empty nick names and invalid characters ':'.

        .DESCRIPTION
        See .SYNOPSIS

        .PARAMETER NickNames
        Specifies the path alias dictionary to verify.

        .OUTPUTS
        True, if no duplicates are detected. Otherwise false.
    #>

    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [hashtable]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        $NickNames
    )

    try {
        if ($NickNames.Count -eq 0) {
            Write-Verbose "No entries present."
            return $false
        }
    
        if (-not (Confirm-UniqueValues -Values $NickNames.Keys)) {
            Write-Warning "NickNames contain duplicate keys. NickName keys must be unique."
            return $false
        }
    
        [string[]]$allValues = @()
        foreach($value in $NickNames.Values) {
            if (-not (Confirm-ValidAliases -Aliases $value)) {
                return $false
            }
    
            $allValues += @($value.Split(';'))
        }
    
        if (-not (Confirm-UniqueValues -Values $allValues)) {
            Write-Warning "NickNames contain duplicate alias entries."
            return $false
        }
    } catch {
        Write-Warning "Failed to verify unique nick names. Reason: $($_.Exception.Message)"
        return $false
    }

    Write-Verbose "All nick name entries check out. We're good to go."
    return $true
}
