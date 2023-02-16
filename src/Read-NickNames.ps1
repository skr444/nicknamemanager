function Read-NickNames {
    <#
        .SYNOPSIS
        [Internal] Reads the nick name entries from the storage file.

        .DESCRIPTION
        This is the default method for obtaining the nick name entries from the storege file.

        .OUTPUTS
        A hashtable with the following structure:

        Key = folderPath (these values must be unique) : string
        Value = [semicolon separated list of aliases associated to its key] : string

        Or an empty hashtable, if something went wrong.
    #>

    [CmdletBinding()]
    [OutputType([hashtable])]
    param()

    [hashtable]$nicks = @{}

    if ([string]::IsNullOrEmpty($NickNameStoreFullpath)) {
        Write-Warning "`$NickNameStoreFullpath variable is empty. Please set a path string of a valid storage file."
        return $nicks
    }

    if (-not (Test-Path -Path $NickNameStoreFullpath)) {
        Write-Warning "Nick name store not found: '$NickNameStoreFullpath'. Please set `$NickNameStoreFullpath"
        return $nicks
    }

    try {
        $content = Get-Content -Path $NickNameStoreFullpath -Encoding utf8 -Raw
        if (-not [string]::IsNullOrEmpty($content)) {
            $nicks = $content | ConvertTo-HashTable
        }

        if ($nicks.Count -gt 0) {
            if (Confirm-ValidNickNames -NickNames $nicks) {
                Write-Verbose "Read $($nicks.Count) valid nick name entries from file from the store at $NickNameStoreFullpath"
                return $nicks
            }
        } else {
            Write-Warning "No values read from file."
        }
    } catch {
        Write-Warning "Failed to read nick name entries from file. Reason: $($_.Exception.Message)"
    }

    return $nicks
}
