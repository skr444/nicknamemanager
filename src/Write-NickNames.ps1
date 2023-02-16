function Write-NickNames {
    <#
        .SYNOPSIS
        [Internal] Writes the nick name entries to the storage file.

        .DESCRIPTION
        This is the default method for persisting nick name entries to the storege file.

        .PARAMETER NickNames
        A hashtable of nick name entries with the following structure:

        Key = folderPath (these values must be unique) : string
        Value = [semicolon separated list of aliases associated to its key] : string

        .INPUTS
        Accepts values from pipe.

        .OUTPUTS
        True, if the write operation was successful, otherwise false.
    #>

    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [hashtable]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        $NickNames
    )

    if ([string]::IsNullOrEmpty($NickNameStoreFullpath)) {
        Write-Warning "`$NickNameStoreFullpath variable is empty. Please set a path string of a valid storage file."
        return $false
    }

    try {
        if (-not (Test-Path -Path $NickNameStoreFullpath)) {
            Write-Verbose "Storage file $NickNameStoreFullpath does not exist. Creating it.."
            New-Item -Path ($NickNameStoreFullpath | Split-Path -Parent) -ItemType Directory -Force
            New-Item -Path $NickNameStoreFullpath -ItemType File -Force
        }

        if ($NickNames.Count -gt 0) {
            if (Confirm-ValidNickNames -NickNames $NickNames) {
                $NickNames | ConvertFrom-HashTable | Set-Content -Path $NickNameStoreFullpath -Encoding utf8
                Write-Verbose "Wrote $($NickNames.Count) nick name entries to the store at $NickNameStoreFullpath"
                return $true
            }
        } else {
            Write-Warning "No values written to file because none were provided."
        }
    } catch {
        Write-Warning "Failed to write nick name entries to file. Reason: $($_.Exception.Message)"
    }

    return $false
}
