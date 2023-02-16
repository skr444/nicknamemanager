function ConvertFrom-HashTable {
    <#
        .SYNOPSIS
        [Internal] Creates a default set of aliases for frequently used path locations.

        .DESCRIPTION
        See .SYNOPSIS

        .INPUTS
        A hashtable with the following structure:

        Key = folderPath (these values must be unique) : string
        Value = [semicolon separated list of aliases associated to its key] : string

        Accepts input from the pipe.

        .OUTPUTS
        A multiline string with the following structure:

        1 entry per line: {key}={value}
        {key} = folderPath (these values must be unique) : string
        {value} = [semicolon separated list of aliases associated to its key] : string
    #>

    [CmdletBinding()]
    [OutputType([string])]
    param(
        [hashtable]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        $NickNames
    )

    [string]$Deliminator = "="
    [string]$LineBreak = [System.Environment]::NewLine

    $text = ""

    try {
        foreach ($nick in $NickNames.GetEnumerator()) {
            $text += "$($nick.Key)${Deliminator}$($nick.Value)${LineBreak}"
        }
    } catch {
        Write-Warning "Failed to assemble input provided by `$NickNames into string. Reason: $($_.Exception.Message)"
    }

    return $text
}
