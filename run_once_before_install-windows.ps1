
Write-Host "🎉 First run install, need to setup some pre-reqs" -ForegroundColor Green

# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-ExecutionPolicy Unrestricted -File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -Wait -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

Write-Host "⭐ Admin level achieved.." -ForegroundColor DarkRed
Set-ExecutionPolicy Unrestricted -ErrorAction Stop

if(Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "🖥️ Installing software from winget"
    winget import -i "$(chezmoi source-path)/winget-install.json" --accept-source-agreements --accept-package-agreements --no-upgrade --disable-interactivity
} else {
    Write-Host "No winget installed"
}