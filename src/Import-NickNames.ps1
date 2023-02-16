function Import-NickNames {
    <#
        .SYNOPSIS
        Imports the nicknames from the old script.

        .DESCRIPTION
        See .SYNOPSIS

        .PARAMETER Path
        Specifies the path to the file containing the data to import.

        .OUTPUTS
        True, if the import succeeds, otherwise false.
    #>

    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [string]
        [Parameter(Mandatory = $true)]
        $Path
    )

    #region functions

    function Get-Count {
        param (
            [hashtable]$Nicks
        )

        $count = 0

        if (-not $Nicks) {
            return $count
        }

        try {
            $count = $Nicks.Count
        } catch {
            Write-Debug "Cannot get `$Nicks count. Reason: $($_.Exception.Message)"
        }

        return $count
    }

    #endregion functions

    if (-not (Test-Path -Path $Path)) {
        Write-Warning "File not found: $Path"
        return $false
    }

    [hashtable]$nicks = @{}

    # try accessing the $NickNames variable in the old script
    $tryAccessFileScriptBlock = {
        param (
            [string]$pPath
        )

        $nicks = @{}

        try {
            . $pPath r
            if ($NickNames -and ($NickNames.Count -gt 0)) {
                $nicks = $NickNames
            }
        } catch {}

        return $nicks
    }
    
    $count = 0

    try {
        # run the access attempt in a child scope
        Write-Verbose "Attempting to access old script file $Path.."
        $nicks = Invoke-Command -ScriptBlock $tryAccessFileScriptBlock -ArgumentList $Path
        $count = Get-Count -Nicks $nicks
    } catch {
        Write-Warning "Failed to load values from old script file. Reason: $($_.Exception.Message)"
    }

    if ($count -eq 0) {
        try {
            # try reading from text file
            Write-Verbose "Attempting to access text file $Path.."
            $nicks = Get-Content -Path $Path -Encoding utf8 -Raw | ConvertTo-HashTable
            $count = Get-Count -Nicks $nicks
        } catch {
            Write-Warning "Failed to load values from text file. Reason: $($_.Exception.Message)"
        }
    }

    if ($count -gt 0) {
        Write-Verbose "Loaded $count entries from file: $Path"

        if (Confirm-ValidNickNames -NickNames $nicks) {
            Write-Output "Entries from file check out. Do you want to import them?"

            $choice = Read-Host -Prompt "Type 'yes' to continue, press ENTER to abort."
            if ($choice.ToLowerInvariant() -eq "yes") {
                if ($nicks | Write-NickNames) {
                    Write-Verbose "Successfully imported $($nicks.Count) entries from file: $Path"
                    return $true
                }
            } else {
                Write-Verbose "Import aborted by user."
            }
        } else {
            Write-Warning "Loaded entries are invalid."
        }
    } else {
        Write-Warning "No entries imported. Run the command again with -Verbose and -Debug to get more info."
    }

    return $false
}
