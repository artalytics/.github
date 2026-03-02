# art CLI installer for Windows
# Downloads the latest release binary from GitHub.
# Repo is private — requires GITHUB_TOKEN.
#
# Usage:
#   $env:GITHUB_TOKEN = "ghp_..."
#   irm https://raw.githubusercontent.com/artalytics/.github/main/install/cli/art.ps1 | iex

$ErrorActionPreference = "Stop"

$Repo = "artalytics/art-cli"
$InstallDir = "$env:USERPROFILE\.local\bin"

# ── Auth check ──────────────────────────────────────────────
if (-not $env:GITHUB_TOKEN) {
    Write-Host "Error: GITHUB_TOKEN is required to download art (private repo)." -ForegroundColor Red
    Write-Host ""
    Write-Host "Get a PAT from: https://github.com/settings/tokens"
    Write-Host "  Required scope: repo (Full control of private repositories)"
    Write-Host ""
    Write-Host "Then run:"
    Write-Host '  $env:GITHUB_TOKEN = "ghp_..."'
    Write-Host "  irm https://raw.githubusercontent.com/artalytics/.github/main/install/cli/art.ps1 | iex"
    exit 1
}

$Headers = @{ Authorization = "token $env:GITHUB_TOKEN" }

# ── Detect architecture ─────────────────────────────────────
$Arch = if ([System.Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture -eq "X64") { "x64" } else { "arm64" }
$Target = "win-$Arch"
$BinaryName = "art-$Target.exe"

Write-Host "Installing art for $Target..."

# ── Download latest release ──────────────────────────────────
try {
    $Release = Invoke-RestMethod -Uri "https://api.github.com/repos/$Repo/releases/latest" -Headers $Headers
} catch {
    Write-Host "Error: Failed to fetch release info. Check your GITHUB_TOKEN." -ForegroundColor Red
    exit 1
}

$Asset = $Release.assets | Where-Object { $_.name -eq $BinaryName } | Select-Object -First 1

if (-not $Asset) {
    Write-Host "Error: No binary found for $Target in latest release." -ForegroundColor Red
    Write-Host "Available at: https://github.com/$Repo/releases"
    exit 1
}

# Create install directory
if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

$OutputPath = Join-Path $InstallDir "art.exe"
$DownloadHeaders = @{
    Authorization = "token $env:GITHUB_TOKEN"
    Accept = "application/octet-stream"
}
Invoke-WebRequest -Uri $Asset.url -Headers $DownloadHeaders -OutFile $OutputPath

Write-Host "  Installed: $OutputPath"

# ── Ensure PATH includes install dir ────────────────────────
$UserPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($UserPath -notlike "*$InstallDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$InstallDir;$UserPath", "User")
    Write-Host "  Added $InstallDir to user PATH (restart terminal to take effect)"
}

# ── Check for Claude Code ───────────────────────────────────
$ClaudeExists = Get-Command claude -ErrorAction SilentlyContinue
if (-not $ClaudeExists) {
    Write-Host ""
    Write-Host "Claude Code not found. Installing..."
    irm https://claude.ai/install.ps1 | iex
}

Write-Host ""
Write-Host "Done! Next steps:"
Write-Host "  art login    # Authenticate with Claude"
Write-Host "  art setup    # Install plugins and build profiles"
