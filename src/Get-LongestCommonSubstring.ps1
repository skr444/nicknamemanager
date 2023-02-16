function Get-LongestCommonSubstring {
    <#
        .SYNOPSIS
        [Internal] Finds the path with the longest common part from a bunch of paths.

        .DESCRIPTION
        See .SYNOPSIS

        .PARAMETER Paths
        Specifies an array of paths to compare and find the common part of.

        .OUTPUTS
        The path with the longest common part of all the input objects.
    #>

    [CmdletBinding()]
    [OutputType([System.IO.DirectoryInfo])]
    param (
        [System.IO.DirectoryInfo[]]
        [Parameter(Mandatory = $true)]
        $Paths
    )
    
    $shortest = $Paths | Sort-Object -Property @{ Expression = { $_.FullName.Length } } | Select-Object -First 1
    Write-Debug "shortest: $shortest"

    $common = ($shortest.FullName.Length..1 | ForEach-Object {
        $shortest.FullName.Substring(0, $_)
    } | Where-Object {
        @(@($Paths | Select-Object -Property FullName) -match [regex]::Escape($_)).Count -eq $Paths.Count
    } | Select-Object -First 1)

    Write-Debug "common: $common"

    return [System.IO.DirectoryInfo]::new($common)
}
