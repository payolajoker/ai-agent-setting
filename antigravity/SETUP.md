# Antigravity (Gemini) - New Machine Setup

This document is for **Antigravity (AI agent)** to read and execute when setting up a new machine.

## When to use

User provides this repo URL (`https://github.com/payolajoker/ai-agent-setting.git`) and asks to set up global settings.

## Setup Steps

### 1. Clone the repo (if not already cloned)
```bash
git clone https://github.com/payolajoker/ai-agent-setting.git <temp-dir>
```

### 2. Create Global Configuration Directory
```bash
mkdir -p ~/.gemini/skills
```

### 3. Copy GLOBAL_GEMINI.md
```bash
cp <repo>/antigravity/GLOBAL_GEMINI.md ~/.gemini/GEMINI.md
```

### 4. Copy skills/
```bash
cp -r <repo>/antigravity/skills/* ~/.gemini/skills/
```

### 5. Verification
Check if `~/.gemini/GEMINI.md` exists and contains the skill paths pointing to `~/.gemini/skills`.

## Sync
To sync changes back to the repo, copy the files from `~/.gemini` back to `antigravity/` folder in this repo and push.
