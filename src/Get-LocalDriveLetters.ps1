function Get-LocalDriveLetters {
    <#
        .SYNOPSIS
        [Internal] Gets a list of locally available drive letters.

        .DESCRIPTION
        See .SYNOPSIS

        .OUTPUTS
        An array of drive letters.
    #>

    [CmdletBinding()]
    [OutputType([string[]])]
    param ()

    return Get-PSDrive -PSProvider FileSystem `
        | Where-Object -Property Name -Match "^.$" `
        | Select-Object -Property Name -Unique `
        | Sort-Object
}
