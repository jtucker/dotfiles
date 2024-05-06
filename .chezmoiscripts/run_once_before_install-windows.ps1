
Write-Host "🎉 First run install, need to setup some pre-reqs" -ForegroundColor Green

if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "winget not found. Exiting"
    return
}

Write-Host "⌛ Updating winget source"
winget source update

## check for git
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "🖥️ Installing Git"
    winget install --id Git.Git `
        --custom '/components="gitlfs,scalar" /o:EditorOption=VisualStudioCode /o:DefaultBranchOption=main /o:PathOption=Cmd /o:SSHOption=ExternalOpenSSH /o:CurlOption=WinSSL /o:BashTerminalOption=ConHost /o:GitPullBehaviorOption=Rebase /o:UseCredentialManager=Enabled' `
        --silent --accept-package-agreements --accept-source-agreements
    Write-Host "🖥️ Installed Git"
}

## Check for sudo
if (-not (Get-Command gsudo -ErrorAction SilentlyContinue)) {
    Write-Host "🖥️ Installing sudo"
    winget install --id gerardog.gsudo `
        --silent --accept-package-agreements --accept-source-agreements
    Write-Host "🖥️ Installed sudo"
}

if (-not (Get-Command age -ErrorAction SilentlyContinue)) {
    Write-Host "🔐 Install age"
    winget install --id FiloSottile.age `
        --silent --accept-package-agreements --accept-source-agreements
    Write-Host "🔐 Installed age"

    # Update the env path so we can 
    # get where age was installed.
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# Update the path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

gsudo {
    Write-Host "⭐ Admin level achieved.." -ForegroundColor DarkRed
    Set-ExecutionPolicy Unrestricted -ErrorAction Stop

    Write-Host "🖥️ Installing software from winget" -ForegroundColor DarkRed
    
}