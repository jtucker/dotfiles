if (Get-Module -ListAvailable -Name PSFzf) {
    Import-Module -Name PSFzf
}
else {
    Install-Module -Scope CurrentUser PSFzf
    Import-Module -Name PSFzf
}

# Set FZF for PsReadline Provider
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PSReadLineOption -PredictionSource History

# Set eza aliases
function Invoke-Eza {
    eza --long --header --all --icons --git --group-directories-first --git-repos
}


Remove-Alias -Name ls
Set-Alias -Name ls -Value Invoke-Eza
Set-Alias -Name ll -Value Invoke-Eza
Set-Alias -Name la -Value Invoke-Eza

