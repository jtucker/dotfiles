
# Load up the common functions
. .\common.ps1
Update-EnvironmentVariables

if (-not (Get-Command op -ErrorAction SilentlyContinue)) {
    Write-Host "Installing 1Password.."

    # CLI
    winget install --id AgileBits.1Password.CLI --silent --accept-package-agreements --accept-source-agreements 

    # GUI
    winget install --id AgileBits.1Password --silent --accept-package-agreements --accept-source-agreements
}

if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    # CLI
    Write-Host "Installing PowerShell Core"
    winget install --id Microsoft.PowerShell --silent --accept-package-agreements --accept-source-agreements 
}

Update-EnvironmentVariables