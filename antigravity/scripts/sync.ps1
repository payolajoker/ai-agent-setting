$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Get-Item $ScriptDir).Parent.Parent.FullName
$GeminiDir = [System.IO.Path]::Combine($env:USERPROFILE, ".gemini")
$SkillsDir = [System.IO.Path]::Combine($GeminiDir, "skills")

Write-Host "Syncing Antigravity (Gemini) settings to repo..."

# 1. Pull latest changes
Set-Location $RepoRoot
git pull
if ($LASTEXITCODE -ne 0) {
    Write-Error "Git pull failed. Please check your network or repo status."
}

# 2. Sync GLOBAL_GEMINI.md
$SourceConfig = Join-Path $GeminiDir "GEMINI.md"
$DestConfig = Join-Path $RepoRoot "antigravity\GLOBAL_GEMINI.md"

if (Test-Path $SourceConfig) {
    Copy-Item -Path $SourceConfig -Destination $DestConfig -Force
    Write-Host "Synced: $SourceConfig -> $DestConfig"
} else {
    Write-Warning "Local config not found at $SourceConfig"
}

# 3. Sync Skills
if (Test-Path $SkillsDir) {
    $DestSkills = Join-Path $RepoRoot "antigravity\skills"
    # Create destination if missing, but usually it exists in repo
    if (-not (Test-Path $DestSkills)) {
        New-Item -ItemType Directory -Path $DestSkills | Out-Null
    }
    Copy-Item -Path "$SkillsDir\*" -Destination $DestSkills -Recurse -Force
    Write-Host "Synced skills from $SkillsDir"
} else {
    Write-Warning "Local skills not found at $SkillsDir"
}

# 4. Git Status & Push
$gitStatus = git status --porcelain
if ($gitStatus) {
    Write-Host "Changes detected. Pushing to remote..."
    git add .
    git commit -m "Sync Antigravity settings from local machine"
    git push
    Write-Host "✅ Sync complete!"
} else {
    Write-Host "✅ No changes to sync."
}
