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

$fontsToInstall = Get-ChildItem -Path (Join-Path $HOME ".fonts") -Recurse -Filter *.otf
if($null -ne $fontsToInstall)
{
    $fontsToInstall `
    | Select-Object { $_.FullName } -ExpandProperty FullName `
    | ForEach-Object { 
        $fontName = ($_.Split("\") | Select-Object -Last 1)
        Write-Host "Installing font: $fontName"
        Install-Font -FileName $_
    }
}
