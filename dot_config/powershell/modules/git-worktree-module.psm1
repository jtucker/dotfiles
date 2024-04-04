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

<#
.SYNOPSIS
Creates a new Git worktree for a specified branch.

.DESCRIPTION
The New-GitBranchWorktree function creates a new Git worktree for a given branch. It allows you to work on different branches simultaneously without switching between them.

.PARAMETER Name
Specifies the name of the new worktree. This should be a unique identifier for the worktree.

.PARAMETER BranchExists
Indicates whether the branch already exists. If this switch is provided, the function will create a new branch with the specified name. Otherwise, it will use an existing branch.

.EXAMPLE
New-GitBranchWorktree -Name "my-feature-branch"
Creates a new worktree for the existing branch named "my-feature-branch".

.EXAMPLE
New-GitBranchWorktree -Name "my-new-branch" -BranchExists
Creates a new worktree and a new branch named "my-new-branch".

.NOTES
- You must be in the root of a bare Git repository to create a worktree.
- The function uses the 'git worktree add' command internally.
#>
function New-GitBranchWorktree {
    param(
        [Parameter(Mandatory)]
        [string] 
        $Name,

        [switch]
        $BranchExists
    )

    if (-not (Test-Path ".base")) {
        Write-Error "You must be in the root of a bare git repository to create a worktree." `
            -ErrorAction Stop
    } 

    $gitCommand = "git"
    $arguments = "worktree", "add" 
    if ($BranchExists)
    {
        $arguments += "-b"
    }

    $arguments += $Name, $Name

    &$gitCommand $arguments
}


Export-ModuleMember -Function 'New-GitBareRepo', 'New-GitBranchWorktree'