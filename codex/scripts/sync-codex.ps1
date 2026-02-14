#Requires -Version 7.0

param(
  [string]$Remote = "origin",
  [string]$Branch = "",
  [string]$RepoRoot = ""
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

function Write-Status($Message) {
  Write-Host "[codex-sync] $Message" -ForegroundColor Cyan
}

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
  $scriptDir = Split-Path -Parent $PSCommandPath
  $RepoRoot = Split-Path -Parent $scriptDir
}

if (-not (Test-Path (Join-Path $RepoRoot ".git"))) {
  throw "Not a git repository: $RepoRoot"
}

Push-Location $RepoRoot
try {
  Write-Status "Checking git remote: $Remote"
  if (-not (git remote | Where-Object { $_ -eq $Remote })) {
    Write-Status "Remote '$Remote' is not configured."
    throw "Git remote '$Remote' not found."
  }

  $currentBranch = git rev-parse --abbrev-ref HEAD
  $targetBranch = if ([string]::IsNullOrWhiteSpace($Branch)) { $currentBranch } else { $Branch }

  Write-Status "Sync start: $targetBranch"
  if ($currentBranch -ne $targetBranch) {
    Write-Status "Switching to branch: $targetBranch"
    git checkout $targetBranch
  }

  Write-Status "Pulling latest from $Remote/$targetBranch"
  try {
    git pull --ff-only "$Remote" "$targetBranch"
  } catch {
    Write-Status "Pull skipped (no upstream or non-fast-forward): $($_.Exception.Message)"
  }

  $sourceHome = Join-Path $HOME ".codex"
  $destCodex = Join-Path $RepoRoot "codex"
  if (-not (Test-Path $sourceHome)) {
    throw "Source Codex home not found: $sourceHome"
  }

  Write-Status "Copying GLOBAL_CODEX.md"
  Copy-Item -Path (Join-Path $sourceHome "GLOBAL_CODEX.md") -Destination (Join-Path $destCodex "GLOBAL_CODEX.md") -Force

  Write-Status "Copying config.toml"
  Copy-Item -Path (Join-Path $sourceHome "config.toml") -Destination (Join-Path $destCodex "config.toml") -Force

  $sourceSkills = Join-Path $sourceHome "skills"
  $destSkills = Join-Path $destCodex "skills"
  if (Test-Path $sourceSkills) {
    Write-Status "Syncing skills/"
    if (Test-Path $destSkills) {
      Remove-Item -Recurse -Force $destSkills
    }
    Copy-Item -Path $sourceSkills -Destination $destSkills -Recurse -Force
  } else {
    Write-Status "No local skills directory found at $sourceSkills"
  }

  $status = git status --short -- codex
  if (-not $status) {
    Write-Status "No changes to sync."
    return
  }

  Write-Status "Changes detected. Committing..."
  git add codex
  $message = "chore: sync codex global settings"
  git commit -m $message
  Write-Status "Pushing to $Remote/$targetBranch"
  git push "$Remote" "$targetBranch"
  Write-Status "Sync completed."
} finally {
  Pop-Location
}
