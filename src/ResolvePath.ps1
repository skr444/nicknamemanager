function ResolvePath {
    <#
        .SYNOPSIS
        [Internal] Attempts to resolve a folder path fragment in each available local drives until a single hit is found.

        .DESCRIPTION
        See .SYNOPSIS

        .PARAMETER Fragment
        Specifies the path fragment to resolve.

        .PARAMETER Timeout
        Specifies the timeout after which the operation should be aborted.

        .OUTPUTS
        Returns the first single hit.

        Throws an exception if either none or many folders were found across all local drives.
    #>

    [CmdletBinding()]
    [OutputType([System.IO.DirectoryInfo])]
    param (
        [string]
        [Parameter(Mandatory = $true)]
        $Fragment,

        [int]
        [Parameter(Mandatory = $true)]
        $Timeout
    )

    # get locally available drive letters
    $driveLetters = Get-LocalDriveLetters
    
    Write-Verbose "Seeing drive letters $([string]::Join(", ", $driveLetters))"

    foreach($drive in $driveLetters) {
        Write-Verbose "Searching in drive $drive for fragment '$Fragment'.."

        [System.IO.DirectoryInfo[]]$hits = @()
        $timer = [System.Diagnostics.Stopwatch]::StartNew()

        # run search as background job
        $job = Start-Job -Name "{""letter"":""$drive"",""fragment"":""$Fragment""}" -ScriptBlock {
            [CmdletBinding()]
            param(
                [string]
                [Parameter(Mandatory = $true)]
                $letter,

                [string]
                [Parameter(Mandatory = $true)]
                $fragment
            )

            $result = Get-ChildItem -Path (Join-Path -Path "${letter}:" -ChildPath "") -Directory -Recurse -Filter "*${fragment}*" -ErrorAction SilentlyContinue
            return $result
        } -ArgumentList $drive, $Fragment

        # monitor the job state and wait until job is complete
        Do {
            # abort job and stop monitoring when time is up
            if ($timer.Elapsed.Seconds -ge $Timeout) {
                $job.StopJob()
                $timer.Stop()
                Write-Verbose "Operation timed out after $($timer.Elapsed.Seconds) seconds."
                break
            }

            $waitTime = 500 # ms
            Write-Debug "Job $($job.Name) is in state: $($job.State). Waiting $waitTime ms."
            Start-Sleep -Milliseconds $waitTime

            # stop monitoring when job was cancelled or is stuck
            if (($job.State -eq "Blocked") -or
                ($job.State -eq "Disconnected") -or
                ($job.State -eq "Failed") -or
                ($job.State -eq "Stopped") -or
                ($job.State -eq "Suspended")) {
                    $timer.Stop()
                    Write-Warning "Operation failed after $($timer.Elapsed.Seconds) seconds."
                    break
                }
        } while ($job.State -ne "Completed")

        # when job is complete we can expect a result and we grab it using the Receive-Job cmdlet
        if ($job.State -eq "Completed") {
            $timer.Stop()
            $temp = @(Receive-Job -Job $job)
            $hits = @($temp | ForEach-Object { [System.IO.DirectoryInfo]::new($_.FullName) })
            Write-Verbose "Operation complete after $($timer.Elapsed.Seconds) seconds. Received $($hits.Count) records."
        }

        # job not needed anymore
        Remove-Job -Job $job

        Write-Debug "hits type: $($hits.GetType())"
        Write-Debug "hits: $([string]::Join(", ", $hits))"

        # process result
        if ($hits.Count -eq 1) {
            Write-Debug "single hit: $($hits[0].FullName)"
            return $hits[0]
        }
        if ($hits.Count -gt 1) {
            Write-Debug "multiple hits"
            Write-Debug "hits count: $($hits.Count)"

            $fallback = Get-LongestCommonSubstring -Paths $hits

            Write-Debug "fallback type: $($fallback.GetType())"
            Write-Verbose "Fragment $Fragment is ambiguous in drive $drive. Please increase specificity of Fragment. Falling back to most common path part: $($fallback)"

            return $fallback
        }
        if ($hits.Count -eq 0) {
            Write-Verbose "Fragment $Fragment was not found in drive $drive"
        }
    }

    # no luck on any of the available drives
    throw "Fragment $Fragment was either not found or yielded multiple ambiguous results in drives $([string]::Join(", ", $driveLetters))"
}
