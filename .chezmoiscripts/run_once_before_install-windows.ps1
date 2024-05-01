
Write-Host "🎉 First run install, need to setup some pre-reqs" -ForegroundColor Green

if(!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "winget not found. Exiting"
    return
}

Write-Host "⌛ Updating winget source"
winget source update

## check for git
if(!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "🖥️ Installing Git"
    winget install --id Git.Git `
        --custom '/components="gitlfs,scalar" /o:EditorOption=VisualStudioCode /o:DefaultBranchOption=main /o:PathOption=Cmd /o:SSHOption=ExternalOpenSSH /o:CurlOption=WinSSL /o:BashTerminalOption=ConHost /o:GitPullBehaviorOption=Rebase /o:UseCredentialManager=Enabled' `
        --silent --accept-package-agreements --accept-source-agreements
    Write-Host "🖥️ Installed Git"
}

## Check for sudo
if(!(Get-Command sudo -ErrorAction SilentlyContinue)) {
    Write-Host "🖥️ Installing sudo"
    winget install --id gerardog.gsudo `
        --silent --accept-package-agreements --accept-source-agreements
    Write-Host "🖥️ Installed sudo"
}

# Update the path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

gsudo {
    Write-Host "⭐ Admin level achieved.." -ForegroundColor DarkRed
    Set-ExecutionPolicy Unrestricted -ErrorAction Stop

    Write-Host "🖥️ Installing software from winget" -ForegroundColor DarkRed
    winget import -i "$(chezmoi source-path)/winget-install.json" --accept-source-agreements --accept-package-agreements --no-upgrade --disable-interactivity

    Write-Host "✪ Installing fonts" -ForegroundColor DarkRed
    if(Test-Path ~/OneDrive) {
        $fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
        Get-ChildItem ~/OneDrive/Fonts/current-font/*.ttf | ForEach-Object { 
            Write-Host "`tInstalling font: $($_.FullName)" -ForegroundColor DarkGray
            $fonts.CopyHere($_.FullName) 
        }
    }
}