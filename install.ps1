#!/usr/bin/env pwsh
# Install git-prime-commit on Windows

$ErrorActionPreference = 'Stop'

Write-Host "Installing git-prime-commit..." -ForegroundColor Cyan

# Determine install location
$InstallDir = "$env:LOCALAPPDATA\Programs\git-prime"

if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

# Download the script
$ScriptUrl = if ($env:GIT_PRIME_COMMIT_URL) { $env:GIT_PRIME_COMMIT_URL } else { "https://textonly.github.io/git-prime/git-prime-commit" }
$DestPath = Join-Path $InstallDir "git-prime-commit"

Write-Host "Downloading from $ScriptUrl..." -ForegroundColor Gray

try {
    Invoke-WebRequest -Uri $ScriptUrl -OutFile $DestPath -UseBasicParsing
} catch {
    Write-Error "Failed to download git-prime-commit: $_"
    exit 1
}

Write-Host "Installed to $DestPath" -ForegroundColor Green
Write-Host ""
Write-Host "Usage:" -ForegroundColor Yellow
Write-Host "  python $DestPath `"Your commit message`""
Write-Host "  python $DestPath -m `"Your commit message`""
Write-Host ""

# Check if directory is in PATH
$CurrentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($CurrentPath -notlike "*$InstallDir*") {
    Write-Host "Adding $InstallDir to PATH..." -ForegroundColor Yellow

    $NewPath = "$CurrentPath;$InstallDir"
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")

    Write-Host "PATH updated! Restart your terminal for changes to take effect." -ForegroundColor Green
    Write-Host ""
    Write-Host "Or run this in your current session:" -ForegroundColor Gray
    Write-Host "  `$env:Path += `";$InstallDir`"" -ForegroundColor Gray
} else {
    Write-Host "$InstallDir is already in PATH" -ForegroundColor Green
}

Write-Host ""
Write-Host "Create a git alias for easier usage:" -ForegroundColor Yellow
Write-Host "  git config --global alias.prime-commit '!python $DestPath'" -ForegroundColor Gray
Write-Host ""
Write-Host "Then use: git prime-commit `"message`"" -ForegroundColor Cyan
