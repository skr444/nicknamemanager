function Get-UserResolver {
    <#
        .SYNOPSIS
        [Internal] Returns a function to resolve user name placeholders.

        .DESCRIPTION
        See .SYNOPSIS

        .OUTPUTS
        A script block with the resolver logic.
    #>

    [CmdletBinding()]
    [OutputType([System.Func[string, string]])]
    param ()

    return {
        param (
            [string]$in
        )

        $candidate = $in

        if (-not ($candidate -imatch "\{user\}")) {
            Write-Verbose "No user placeholder found."
            return $in
        }

        $placeHolder = $Matches[0]
        $result = $in -replace $placeHolder, [System.Environment]::UserName
        Write-Verbose "Updated '${in}' to '${result}'."
        return $result
    }
}
