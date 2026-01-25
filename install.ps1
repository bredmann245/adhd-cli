$ErrorActionPreference = "Stop"

$Repo = "bredmann245/adhd-cli"
$Bin  = "adhd.exe"
$InstallDir = if ($env:INSTALL_DIR) { $env:INSTALL_DIR } else { "$env:LOCALAPPDATA\Programs\adhd-cli\bin" }

$Asset = "adhd-Windows.zip"
$Url = "https://github.com/$Repo/releases/latest/download/$Asset"

Write-Host "Downloading: $Url"
$tmp = New-Item -ItemType Directory -Force -Path ([System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "adhd-cli-install"))
$zip = Join-Path $tmp.FullName $Asset

Invoke-WebRequest -Uri $Url -OutFile $zip
Expand-Archive -Path $zip -DestinationPath $tmp.FullName -Force

$exePath = Join-Path $tmp.FullName $Bin
if (!(Test-Path $exePath)) {
  throw "Expected '$Bin' inside the zip root, but didn't find it."
}

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
Copy-Item $exePath (Join-Path $InstallDir $Bin) -Force

Write-Host "Installed $Bin -> $InstallDir\$Bin"
Write-Host "Add to PATH (User):"
Write-Host "  setx PATH `"$InstallDir;$env:PATH`""
Write-Host "Then open a new terminal and run: adhd --help"
