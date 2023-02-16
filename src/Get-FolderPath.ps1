function Get-FolderPath {
    <#
        .SYNOPSIS
        [Internal] Evaluates a path on different drives and replaces the {user} placeholder with the current user name.

        .DESCRIPTION
        See .SYNOPSIS

        .PARAMETER Path
        Specifies the path with possibly non-existing drive letter and placeholders.

        .OUTPUTS
        The path with the correct drive letter and user.
    #>

    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Path,

        [Parameter(Mandatory = $false)]
        [System.Func[string, string][]]
        $ReplaceFunctions = @(
            {
                param ($in)
                return $in -replace "{user}", [System.Environment]::UserName
            }
        )
    )

    [string]$pathCandidate = $Path

    foreach ($func in $ReplaceFunctions) {
        try {
            $pathCandidate = $func.Invoke($pathCandidate)
        } catch {
            Write-Warning "Failed to invoke replace function."
        }
    }

    if (Test-Path -Path $pathCandidate -ErrorAction SilentlyContinue) {
        Write-Verbose "Found path candidate '${pathCandidate}'."
        return $pathCandidate
    }

    $drives = Get-LocalDriveLetters
    $relativePath = Split-Path -Path $pathCandidate -NoQualifier
    Write-Verbose "Looking for '${relativePath}' on all available drives ($([string]::Join(", ", $drives)))."

    foreach ($dl in $drives) {
        $pathCandidate = Join-Path -Path "$($dl.Name):" -ChildPath $relativePath
        Write-Debug "Testing path candidate '${pathCandidate}'.."

        if (Test-Path -Path $pathCandidate -ErrorAction SilentlyContinue) {
            Write-Verbose "Found path candidate '${pathCandidate}'."
            return $pathCandidate
        }
    }

    Write-Warning "${Path} was not found on any available drives."
    return ""
}
