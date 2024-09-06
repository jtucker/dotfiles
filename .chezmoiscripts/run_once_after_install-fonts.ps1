Write-Host -ForegroundColor Green "Installing fonts from the `.fonts` folder"

function Install-Font {
    param(
        [Parameter(Mandatory)]
        [string]$FileName
    )

    $signature = @'
[DllImport("fontext.dll", CharSet = CharSet.Auto)]
public static extern void InstallFontFile(IntPtr hwnd, string filePath, int flags);
'@
   
    $fontextdll = Add-Type -MemberDefinition $signature -Name Invoke -Namespace InstallFontFile -PassThru
    $fontextdll::InstallFontFile( (Get-Process -Id $pid).MainWindowHandle, $FileName, 0 )
}

# Get Fonts in the .fonts folder
$fontsFoundInFolder = Get-ChildItem -Path (Join-Path $HOME ".fonts") -Recurse | Where-Object Extension -in @('.otf', '.ttf')

# Get fonts installed via registry
$fontsRegistryKey = 'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
$fontsInRegistry = Get-Item -Path $fontsRegistryKey -ErrorAction Stop
$fontPathsFromRegistry = $fontsInRegistry.Property | ForEach-Object { $fontsInRegistry.GetValue($_) }

# Get any deltas
$newFontsToInstall = $fontsFoundInFolder | Where-Object { $fontPathsFromRegistry -notcontains $_ }
if($null -ne $newFontsToInstall)
{
    Write-Host "Found $($newFontsToInstall.Count) to install" 
    $newFontsToInstall `
    | Select-Object -ExpandProperty FullName
    | ForEach-Object { 
        $fontName = ($_.Split("\") | Select-Object -Last 1)
        Write-Host "Installing font: $fontName"
        Install-Font -FileName $_
    }
}
