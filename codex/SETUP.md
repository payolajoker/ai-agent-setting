# Codex - New Machine Setup

This document is for **Codex (AI agent)** to read and execute when setting up a new machine.

## When to use

User provides this repo URL (`https://github.com/payolajoker/ai-agent-setting.git`) and asks to set up global settings.

## Setup Steps

### 1. Clone the repo (if not already cloned)
```bash
git clone https://github.com/payolajoker/ai-agent-setting.git <temp-dir>
```

### 2. Copy GLOBAL_CODEX.md
```bash
cp <repo>/codex/GLOBAL_CODEX.md ~/.codex/GLOBAL_CODEX.md
```

### 3. Copy config.toml
```bash
cp <repo>/codex/config.toml ~/.codex/config.toml
```

### 4. Copy skills/
```bash
cp -r <repo>/codex/skills/* ~/.codex/skills/
```

### 5. Restart Codex
Tell the user to restart Codex so config/MCP settings take effect.

## Important Notes
- This repo stores Codex global configuration only.
- NEVER copy local machine files (`auth.json`, `cap_sid`, `sessions/`, `tmp/`, cache/debug folders, and any credentials).
- If files already exist at the destination, overwrite them (repo is the source of truth).
- After setup, the `GLOBAL_CODEX.md` should contain sync-back instructions so future changes are pushed back to this repo.
