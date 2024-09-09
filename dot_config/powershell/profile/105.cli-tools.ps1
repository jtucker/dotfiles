if (Get-Module -ListAvailable -Name PSFzf) {
    Import-Module -Name PSFzf
}
else {
    Install-Module -Scope CurrentUser PSFzf
    Import-Module -Name PSFzf
}


