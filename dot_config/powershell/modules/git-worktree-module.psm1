Set-StrictMode -Version '3.0'

<#
    .SYNOPSIS 
        Creates a new bare git repo from the provided url and creates it either in the current directory
        or a provided directory.

    .PARAMETER GitRepoUrl
        The URL to the remote git repo

    .PARAMETER DestinationFolder
        The optional parameter for where the bare git repo is cloned to. Defaults to the `name` of the repo from the URL.
#>
function New-GitBareRepo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $GitRepoUrl,

        [string]
        $DestinationFolder
    )

    if (-not $DestinationFolder) {
        $DestinationFolder = (Split-Path $GitRepoUrl -Leaf) -replace '\.git$'
    }

    # Clone a bare repo into a `.base` folder 
    git clone --bare $GitRepoUrl (Join-Path $DestinationFolder ".base")

    # Go to that directory containing the bare repo folder
    Push-Location $DestinationFolder

    # Tell git where to get all the required repo files from
    Add-Content -Value "gitdir: ./.base" -Path ".git"

    # Set the remote origin feth rules so we can get remote stuff
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

    # Get a fresh list of branches from origin
    git fetch origin 

    Pop-Location    
}