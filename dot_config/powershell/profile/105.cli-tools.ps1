if (Get-Module -ListAvailable -Name PSFzf) {
    Import-Module -Name PSFzf
}
else {
    Install-Module -Scope CurrentUser PSFzf
    Import-Module -Name PSFzf
}

# Set FZF for PsReadline Provider
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# PS Readline Options
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler "Ctrl+Delete" KillWord
Set-PSReadlineKeyHandler "Ctrl+Backspace" BackwardKillWord
Set-PSReadlineKeyHandler "Ctrl+LeftArrow" BackwardWord
Set-PSReadlineKeyHandler "Ctrl+RightArrow" NextWord
Set-PSReadlineKeyHandler "Tab" MenuComplete
Set-PSReadLineOption -ExtraPromptLineCount 2

# Set eza aliases
if($null -ne (Get-Command eza -ErrorAction Ignore)) {

    function Invoke-Eza {
        eza --header --icons --git --group-directories-first --git-repos --no-permissions --classify=auto @args
    }
    
    function Invoke-EzaLong {
        Invoke-Eza --long @args
    }
    
    function Invoke-EzaHidden {
        Invoke-EzaLong --all @args
    }

    Remove-Alias -Name ls
    Set-Alias -Name ls -Value Invoke-Eza -Scope Global -Option AllScope
    Set-Alias -Name ll -Value Invoke-EzaLong -Scope Global -Option AllScope
    Set-Alias -Name la -Value Invoke-EzaHidden -Scope Global -Option AllScope
}


# Set syntax highlighting colors for PowerShell
$PSReadlineModule = Get-Module -Name PSReadline
if ($null -eq $PSReadlineModule) {
    # If PSReadline isn't loaded, there's nothing to do here
    return
}

if ($PSReadlineModule.Version.Major -ge 2) {
    # Color dictionary supports `ConsoleColor`, hex RGB, or VT control sequences
    Set-PSReadlineOption -Colors @{
        "Comment"   = [ConsoleColor]::DarkCyan
        "Operator"  = [ConsoleColor]::DarkMagenta
        "Variable"  = [ConsoleColor]::Gray
        "Member"    = [ConsoleColor]::Gray
        "Number"    = [ConsoleColor]::Blue
        "Type"      = [ConsoleColor]::Green
        "String"    = [ConsoleColor]::Cyan
        "Parameter" = [ConsoleColor]::Red
        "Keyword"   = [ConsoleColor]::Yellow
        "Command"   = "$([char]0x1b)[97;44m"  # Foreground: White, Background: Blue
        "Default"   = [ConsoleColor]::White
    }
}
else {
    # Use old style color options for PSReadline versions before 2.0
    Set-PSReadlineOption -TokenKind Comment -ForegroundColor DarkCyan
    Set-PSReadlineOption -TokenKind Operator -ForegroundColor DarkMagenta
    Set-PSReadlineOption -TokenKind Variable -ForegroundColor Gray
    Set-PSReadlineOption -TokenKind Member -ForegroundColor Gray
    Set-PSReadlineOption -TokenKind Number -ForegroundColor Blue
    Set-PSReadlineOption -TokenKind Type -ForegroundColor Green
    Set-PSReadlineOption -TokenKind String -ForegroundColor Cyan
    Set-PSReadlineOption -TokenKind Parameter -ForegroundColor Red
    Set-PSReadlineOption -TokenKind Keyword -ForegroundColor Yellow
    Set-PSReadlineOption -TokenKind Command -ForegroundColor White
    Set-PSReadlineOption -TokenKind Command -BackgroundColor DarkBlue
    Set-PSReadlineOption -TokenKind None -ForegroundColor White
}

