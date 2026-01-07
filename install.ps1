#!/usr/bin/env pwsh
# Install git-prime tools on Windows

$ErrorActionPreference = 'Stop'

Write-Host "Installing git-prime tools..." -ForegroundColor Cyan

# Determine install location
$InstallDir = "$env:LOCALAPPDATA\Programs\git-prime"

if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

$BaseUrl = "https://textonly.github.io/git-prime"
$Tools = @("git-prime-commit", "git-prime-log")

foreach ($Tool in $Tools) {
    $ScriptUrl = "$BaseUrl/$Tool"
    $DestPath = Join-Path $InstallDir $Tool
    $WrapperPath = Join-Path $InstallDir "$Tool.cmd"

    Write-Host "Downloading $Tool..." -ForegroundColor Gray

    try {
        Invoke-WebRequest -Uri $ScriptUrl -OutFile $DestPath -UseBasicParsing
    } catch {
        Write-Error "Failed to download $Tool: $_"
        continue
    }

    # Create a batch wrapper so it runs automatically as a git subcommand
    # This removes the need for manual git aliases
    $BatchContent = "@echo off`r`npython `"%~dp0\$Tool`" %*"
    Set-Content -Path $WrapperPath -Value $BatchContent
}

Write-Host ""
Write-Host "✓ Installed to $InstallDir" -ForegroundColor Green
Write-Host ""
Write-Host "Usage:" -ForegroundColor Yellow
Write-Host "  git prime-commit `"message`""
Write-Host "  git prime-log"
Write-Host ""

# Check if directory is in PATH
$CurrentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($CurrentPath -notlike "*$InstallDir*") {
    Write-Host "Adding $InstallDir to PATH..." -ForegroundColor Yellow

    $NewPath = "$CurrentPath;$InstallDir"
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")

    Write-Host "PATH updated! Restart your terminal for changes to take effect." -ForegroundColor Green
    Write-Host ""
    Write-Host "Or run this in your current session to use immediately:" -ForegroundColor Gray
    Write-Host "  `$env:Path += `";$InstallDir`"" -ForegroundColor Gray
} else {
    Write-Host "PATH is already configured." -ForegroundColor Green
}
