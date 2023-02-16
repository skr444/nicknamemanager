function Get-SpecialFolderResolver {
    <#
        .SYNOPSIS
        [Internal] Returns a function to resolve special folder placeholders.

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

        if (-not $candidate.StartsWith("{")) {
            Write-Verbose "Special folder placeholder is not at the beginning of the path."
            return $in
        }

        if (-not ($candidate -imatch "^\{.+\}")) {
            Write-Verbose "No placeholder found."
            return $in
        }

        $placeHolder = $Matches[0]
        Write-Verbose "Found placeholder '${placeHolder}'."
        $specialFolder = [System.Environment+SpecialFolder]::Personal

        try {
            $specialFolder = [System.Environment+SpecialFolder](($placeHolder -replace "\{", "") -replace "\}", "")
            Write-Verbose "Parsed special folder: '${specialFolder}'."
        } catch {
            Write-Verbose "Placeholder value '${placeHolder}' is not a special folder."
            return $in
        }

        $result = $in -replace $placeHolder, [System.Environment]::GetFolderPath($specialFolder)
        Write-Verbose "Updated '${in}' to '${result}'."
        return $result
    }
}
