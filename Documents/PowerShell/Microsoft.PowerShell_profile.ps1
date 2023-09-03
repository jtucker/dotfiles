
# ----------------
# Profile loader
# ----------------

$config = Join-Path $env:USERPROFILE "/.config/powershell/profile"
if (Test-Path $config) {
    $configs = Get-ChildItem -Path $config -Filter "*.ps1" -File
    foreach($file in $configs) {
        . $file.FullName
    }
}