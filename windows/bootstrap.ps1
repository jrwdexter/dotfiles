# Windows dotfiles bootstrap.
#
# Nix cannot run on native Windows, so this script is the deployment mechanism
# there: it symlinks the shared, OS-agnostic configs (neovim, windows-terminal)
# into their native Windows locations. The same files are consumed on Linux/WSL
# by the home-manager module in ../flake.nix.
#
# Run from an ADMIN PowerShell (symlink creation needs elevation unless Windows
# Developer Mode is enabled):
#     pwsh -ExecutionPolicy Bypass -File .\windows\bootstrap.ps1
#
# Idempotent: re-running replaces existing symlinks, but refuses to clobber a
# real (non-symlink) file so nothing is lost by accident.

$ErrorActionPreference = 'Stop'

# Repo root = parent of this script's directory.
$Repo = Split-Path -Parent $PSScriptRoot

# native Windows target  ->  source path in this repo
$Links = [ordered]@{
    "$env:LOCALAPPDATA\nvim" = "$Repo\.config\nvim"
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" = "$Repo\.windows-terminal\settings.json"
}

function New-DotfileLink {
    param([string]$Target, [string]$Source)

    if (-not (Test-Path $Source)) {
        Write-Warning "Source missing, skipping: $Source"
        return
    }

    if (Test-Path $Target) {
        $item = Get-Item $Target -Force
        if ($item.LinkType -eq 'SymbolicLink') {
            Remove-Item $Target -Force -Recurse
        }
        else {
            Write-Warning "Real file exists at target, refusing to overwrite: $Target"
            return
        }
    }

    $parent = Split-Path -Parent $Target
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }

    New-Item -ItemType SymbolicLink -Path $Target -Target $Source | Out-Null
    Write-Host "linked  $Target  ->  $Source"
}

foreach ($t in $Links.Keys) { New-DotfileLink -Target $t -Source $Links[$t] }

Write-Host "`nDone." -ForegroundColor Green
