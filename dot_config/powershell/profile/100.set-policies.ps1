if ((Get-PSRepository | Select-Object -ExpandProperty InstallationPolicy) -eq "Untrusted") {
    gsudo { 
        Write-Host "Installing NuGet Package Provider"
        Install-PackageProvider -Name NuGet -Force
        Write-Host "Setting PSGallery to trusted"
        Set-PSRepository PSGallery -InstallationPolicy Trusted
    }
}