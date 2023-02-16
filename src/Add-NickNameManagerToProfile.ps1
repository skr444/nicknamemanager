function Add-NickNameManagerToProfile {
    <#
        .SYNOPSIS
        Adds the module to the Powershell profile.

        .DESCRIPTION
        See .SYNOPSIS

        .PARAMETER ProfileName
        Name of the Powershell profile this package should be registered with.

        .OUTPUTS
        True, if the module was successfully added to the profile, otherwise false.
    #>

    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [string]
        [Parameter(Mandatory = $false)]
        [ValidateSet("CurrentUserCurrentHost", "CurrentUserAllHosts", "AllUsersCurrentHost", "AllUsersAllHosts")]
        [Alias("P")]
        $ProfileName = "CurrentUserAllHosts"
    )

    [string]$ImportInstruction = "Import-Module -Name NickNameManager"

    $path = ""

    switch ($ProfileName) {
        "CurrentUserCurrentHost" { $path = $PROFILE.CurrentUserCurrentHost; break }
        "CurrentUserAllHosts" { $path = $PROFILE.CurrentUserAllHosts; break }
        "AllUsersCurrentHost" { $path = $PROFILE.AllUsersCurrentHost; break }
        "AllUsersAllHosts" { $path = $PROFILE.AllUsersAllHosts; break }
    }

    if (Test-Path -Path $path) {
        if ((Get-Content -Path $path) -imatch $ImportInstruction) {
            Write-Warning "Module NickNameManager already added to profile under $path"
            return $false
        }

        Write-Output "About to add the module to the Powershell profile in $path"
        $choice = Read-Host -Prompt "Type 'yes' to continue, press ENTER to abort."
        if ($choice.ToLowerInvariant() -eq 'yes') {
            Add-Content -Path $path -Value ""
            Add-Content -Path $path -Value $ImportInstruction

            if ((Get-Content -Path $path) -imatch $ImportInstruction) {
                Write-Verbose "Successfully added NickNameManager to profile."
                return $true
            } else {
                Write-Warning "Failed to import module. Run the command again with -Verbose and -Debug to get more info."
            }
        } else {
            Write-Verbose "Add to profile aborted by user."
        }
    } else {
        Write-Warning "Profile $ProfileName does not exist. Please create it first and try again."
    }

    return $false
}
