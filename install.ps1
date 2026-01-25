# install.ps1
$ErrorActionPreference = "Stop"

function Normalize-Path([string]$p) {
  if ([string]::IsNullOrWhiteSpace($p)) { return "" }
  return ($p.Trim().TrimEnd('\')).ToLowerInvariant()
}

$Repo = "bredmann245/adhd-cli"
$Bin  = "adhd.exe"

# Default install dir: WindowsApps (often already on PATH; friendly for PowerShell/cmd/Git Bash)
$InstallDir = if ($env:INSTALL_DIR) { $env:INSTALL_DIR } else { "$env:LOCALAPPDATA\Microsoft\WindowsApps" }

$Asset = "adhd-Windows.zip"
$Url = "https://github.com/$Repo/releases/latest/download/$Asset"

Write-Host "⬇️  Downloading: $Url"

$tmpRoot = [System.IO.Path]::GetTempPath()
$tmpName = "adhd-cli-install-" + [System.Guid]::NewGuid().ToString("N")
$tmp = New-Item -ItemType Directory -Force -Path (Join-Path $tmpRoot $tmpName)

try {
  $zip = Join-Path $tmp.FullName $Asset

  Invoke-WebRequest -Uri $Url -OutFile $zip
  Expand-Archive -Path $zip -DestinationPath $tmp.FullName -Force

  $exePath = Join-Path $tmp.FullName $Bin
  if (!(Test-Path $exePath)) {
    throw "Expected '$Bin' inside the zip root, but didn't find it. Ensure the zip contains '$Bin' at the top level."
  }

  New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
  $dest = Join-Path $InstallDir $Bin
  Copy-Item $exePath $dest -Force

  # Persist to User PATH (only if needed)
  $old = [Environment]::GetEnvironmentVariable("Path", "User")
  if ([string]::IsNullOrWhiteSpace($old)) { $old = "" }

  $parts = $old -split ";" | Where-Object { $_ -and $_.Trim() -ne "" }
  $targetNorm = Normalize-Path $InstallDir
  $partsNorm = $parts | ForEach-Object { Normalize-Path $_ }

  if ($partsNorm -notcontains $targetNorm) {
    $new = if ($old -eq "") { $InstallDir } else { "$InstallDir;$old" }
    [Environment]::SetEnvironmentVariable("Path", $new, "User")
    Write-Host "✅ Added to User PATH: $InstallDir"
  } else {
    Write-Host "ℹ️ Already in User PATH: $InstallDir"
  }

  # Update current session PATH so it works immediately (PowerShell)
  $sessionPartsNorm = ($env:Path -split ";") | ForEach-Object { Normalize-Path $_ }
  if ($sessionPartsNorm -notcontains $targetNorm) {
    $env:Path = "$InstallDir;$env:Path"
  }

  Write-Host "✅ Installed $Bin -> $dest"
  Write-Host "✅ Updated PATH for current session"
  Write-Host ""
  Write-Host "Run: adhd --help"
  Write-Host "Note: If you're using Git Bash, restart Git Bash to pick up PATH changes."
}
finally {
  Remove-Item -Recurse -Force $tmp.FullName -ErrorAction SilentlyContinue
}
