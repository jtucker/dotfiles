# Zoxide setup if installed

if(Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& zoxide init powershell --hook pwd | Out-String)
}