function Update-EnvironmentVariables
{
    @([System.Environment]::GetEnvironmentVariable("Path", "Machine"), [System.Environment]::GetEnvironmentVariable("Path", "User")) -join ";" `
    | Set-Item -Path Env:\Path
}