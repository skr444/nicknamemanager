function ConvertTo-HashTable {
    <#
        .SYNOPSIS
        [Internal] Creates a default set of aliases for frequently used path locations.

        .DESCRIPTION
        See .SYNOPSIS

        .INPUTS
        A multiline string with the following structure:

        1 entry per line: {key}={value}
        {key} = folderPath (these values must be unique) : string
        {value} = [semicolon separated list of aliases associated to its key] : string

        Accepts input from the pipe.

        .OUTPUTS
        A hashtable with the following structure:

        Key = folderPath (these values must be unique) : string
        Value = [semicolon separated list of aliases associated to its key] : string
    #>

    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [string]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        $Text
    )

    [string]$LineBreak = [System.Environment]::NewLine
    [string]$KeyTag = "keyId"
    [string]$ValueTag = "valueId"
    [string]$Pattern = "^(?<keyId>[^\s][^#=]*[^\s])=(?<valueId>[^=\s]*)$"

    [hashtable]$entries = @{}

    try {
        [string[]]$lines = $Text.Split(@($LineBreak), [StringSplitOptions]::RemoveEmptyEntries)

        foreach ($line in $lines) {
            $line -imatch $Pattern | Out-Null
            $entries.Add($Matches[$KeyTag], $Matches[$ValueTag])
        }
    } catch {
        Write-Warning "Failed to parse input provided by `$Text to a hashtable. Reason: $($_.Exception.Message)"
    }

    return $entries
}
