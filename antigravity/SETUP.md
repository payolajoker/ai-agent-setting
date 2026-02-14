# Antigravity (Gemini) - New Machine Setup

This document is for **Antigravity (AI agent)** to read and execute when setting up a new machine.

## When to use

User provides this repo URL (`https://github.com/payolajoker/ai-agent-setting.git`) and asks to set up global settings.

## Setup Steps

### 1. Clone the repo (if not already cloned)
```bash
git clone https://github.com/payolajoker/ai-agent-setting.git <temp-dir>
```

## Setup Steps

### 1. Clone the repo (if not already cloned)
```bash
git clone https://github.com/payolajoker/ai-agent-setting.git <temp-dir>
```

### 2. Run Setup Script

**Windows (PowerShell):**
```powershell
cd <temp-dir>
pwsh ./antigravity/scripts/setup.ps1
```

**Linux / macOS (Bash):**
```bash
cd <temp-dir>
chmod +x ./antigravity/scripts/setup.sh
./antigravity/scripts/setup.sh
```

The script will automatically:
- Create `~/.gemini/skills` directory
- Copy `antigravity/GLOBAL_GEMINI.md` to `~/.gemini/GEMINI.md`
- Copy all skills to `~/.gemini/skills/`

## Sync (Local → Repo)

When you make changes to your local global settings (e.g., adding a new skill or editing `GEMINI.md`), run the sync script to push changes back to this repository.

**Windows (PowerShell):**
```powershell
cd <repo-root>
pwsh ./antigravity/scripts/sync.ps1
```

**Linux / macOS (Bash):**
```bash
cd <repo-root>
chmod +x ./antigravity/scripts/sync.sh
./antigravity/scripts/sync.sh
```

The script will:
1. Pull latest changes from git
2. Copy `~/.gemini/GEMINI.md` → `antigravity/GLOBAL_GEMINI.md`
3. Copy `~/.gemini/skills/*` → `antigravity/skills/*`
4. Commit and push if there are changes
