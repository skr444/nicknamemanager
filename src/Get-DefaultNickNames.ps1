function Get-DefaultNickNames {
    <#
        .SYNOPSIS
        [Internal] Creates a default set of aliases for frequently used path locations.

        .DESCRIPTION
        See .SYNOPSIS

        .OUTPUTS
        A hashtable with the following structure:

        Key = folderPath (these values must be unique) : string
        Value = [semicolon separated list of aliases associated to its key] : string
    #>

    [CmdletBinding()]
    [OutputType([hashtable])]
    param()

    $windowsNicks = @{
        "C:\Users\{user}" = "ud;udata;userdata"
        "C:\ProgramData" = "pd;pdata;programdata"
        "C:\Program Files" = "pf64;pfiles64;programfiles64"
        "C:\Program Files (x86)" = "pf;pfiles;programfiles"
        "D:\repos" = "r;repos"
        "D:\playground" = "pg;playground"
    }

    $linuxNicks = @{
        "/home/{user}" = "h;home;ud;udata;userdata"
        "/etc" = "etc"
        "/usr" = "usr"
        "/var" = "var"
        "/home/{user}/repos" = "r;repos"
        "/home/{user}/playground" = "pg;playground"
    }

    [string]$WindowsPlatform = "Win"

    $platform = [System.Environment]::OSVersion.Platform
    Write-Verbose "Detected platform: $platform"

    if ($platform.ToString().StartsWith($WindowsPlatform)) {
        Write-Verbose "Creating Windows default nick names.."
        return $windowsNicks
    } else {
        Write-Verbose "Creating Linux default nick names.."
        return $linuxNicks
    }
}
