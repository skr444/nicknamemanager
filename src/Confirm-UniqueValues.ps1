function Confirm-UniqueValues {
    <#
        .SYNOPSIS
        [Internal] Verifies that the strings do not contain any duplicate entries.

        .DESCRIPTION
        See .SYNOPSIS

        .PARAMETER Values
        Specifies the path alias dictionary to verify.

        .OUTPUTS
        True, if no duplicates are detected. Otherwise false.
    #>

    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [string[]]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        $Values
    )

    try {
        if ($Values.Count -eq 0) {
            Write-Verbose "No entries present."
            return $false
        }
    
        $unique = @($Values) | Select-Object -Unique
        $difference = Compare-Object -ReferenceObject $unique -DifferenceObject @($Values)
        if ($difference) {
            Write-Warning "Duplicate values: $($difference.InputObject)"
            return $false
        }
    } catch {
        Write-Warning "Failed to verify unique values. Reason: $($_.Exception.Message)"
        return $false
    }

    Write-Debug "No duplicate values found in '$($Values -join ", ")'."
    return $true
}
