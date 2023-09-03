
if (!(Get-InstalledModule Terminal-Icons -ErrorAction SilentlyContinue)) {
    Install-Module Terminal-Icons -Force -Scope CurrentUser -SkipPublisherCheck
}

Import-Module -Name Terminal-Icons
