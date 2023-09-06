# Zoxide setup if installed

if(Get-Command zoxide) {
    Invoke-Expression (& zoxide init powershell --hook pwd | Out-String)
}