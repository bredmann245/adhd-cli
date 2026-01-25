$ErrorActionPreference = "Stop"

$Repo = "bredmann245/adhd-cli"
$Bin  = "adhd.exe"
$InstallDir = if ($env:INSTALL_DIR) { $env:INSTALL_DIR } else { "$env:LOCALAPPDATA\Programs\adhd-cli\bin" }

$Asset = "adhd-Windows.zip"
$Url = "https://github.com/$Repo/releases/latest/download/$Asset"

Write-Host "Downloading: $Url"

$tmpRoot = [System.IO.Path]::GetTempPath()
$tmpName = "adhd-cli-install-" + [System.Guid]::NewGuid().ToString("N")
$tmp = New-Item -ItemType Directory -Force -Path (Join-Path $tmpRoot $tmpName)

try {
  $zip = Join-Path $tmp.FullName $Asset

  Invoke-WebRequest -Uri $Url -OutFile $zip
  Expand-Archive -Path $zip -DestinationPath $tmp.FullName -Force

  $exePath = Join-Path $tmp.FullName $Bin
  if (!(Test-Path $exePath)) {
    throw "Expected '$Bin' inside the zip root, but didn't find it."
  }

  New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
  Copy-Item $exePath (Join-Path $InstallDir $Bin) -Force

  # Persist to User PATH (exact match)
  $old = [Environment]::GetEnvironmentVariable("Path", "User")
  if ([string]::IsNullOrWhiteSpace($old)) { $old = "" }

  $parts = $old -split ";" | Where-Object { $_ -and $_.Trim() -ne "" }
  if ($parts -notcontains $InstallDir) {
    $new = if ($old -eq "") { $InstallDir } else { "$InstallDir;$old" }
    [Environment]::SetEnvironmentVariable("Path", $new, "User")
    Write-Host "✅ Added to User PATH: $InstallDir"
  } else {
    Write-Host "ℹ️ Already in User PATH: $InstallDir"
  }

  # Update current session PATH so the command works immediately
  if (($env:Path -split ";") -notcontains $InstallDir) {
    $env:Path = "$InstallDir;$env:Path"
  }

  Write-Host "✅ Installed $Bin -> $InstallDir\$Bin"
  Write-Host "✅ Updated PATH for current session"
  Write-Host "Run: adhd --help"
}
finally {
  Remove-Item -Recurse -Force $tmp.FullName -ErrorAction SilentlyContinue
}
