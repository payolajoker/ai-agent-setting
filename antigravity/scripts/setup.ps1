$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Get-Item $ScriptDir).Parent.Parent.FullName
$GeminiDir = [System.IO.Path]::Combine($env:USERPROFILE, ".gemini")
$SkillsDir = [System.IO.Path]::Combine($GeminiDir, "skills")

Write-Host "Setting up Antigravity (Gemini) environment..."

# 1. Create .gemini directory
if (-not (Test-Path $GeminiDir)) {
    New-Item -ItemType Directory -Path $GeminiDir | Out-Null
    Write-Host "Created directory: $GeminiDir"
}

# 2. Copy GLOBAL_GEMINI.md -> GEMINI.md
$SourceConfig = Join-Path $RepoRoot "antigravity\GLOBAL_GEMINI.md"
$DestConfig = Join-Path $GeminiDir "GEMINI.md"
Copy-Item -Path $SourceConfig -Destination $DestConfig -Force
Write-Host "Copied configuration: $DestConfig"

# 3. Copy Skills
if (-not (Test-Path $SkillsDir)) {
    New-Item -ItemType Directory -Path $SkillsDir | Out-Null
}
$SourceSkills = Join-Path $RepoRoot "antigravity\skills\*"
Copy-Item -Path $SourceSkills -Destination $SkillsDir -Recurse -Force
Write-Host "Copied skills to: $SkillsDir"

Write-Host "✅ Antigravity setup complete!"
