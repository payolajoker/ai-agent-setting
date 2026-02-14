# Claude Code - New Machine Setup

This document is for **Claude Code (AI agent)** to read and execute when setting up a new machine.

## When to use

User provides this repo URL (`https://github.com/payolajoker/ai-agent-setting.git`) and asks to set up global settings.

## Setup Steps

### 1. Clone the repo (if not already cloned)
```bash
git clone https://github.com/payolajoker/ai-agent-setting.git <temp-dir>
```

### 2. Copy GLOBAL_CLAUDE.md → ~/.claude/CLAUDE.md
```bash
cp <repo>/claude-code/GLOBAL_CLAUDE.md ~/.claude/CLAUDE.md
```

### 3. Copy settings.json → ~/.claude/settings.json
```bash
cp <repo>/claude-code/settings.json ~/.claude/settings.json
```

### 4. Copy skills/ → ~/.claude/skills/
```bash
cp -r <repo>/claude-code/skills/* ~/.claude/skills/
```

### 5. Merge MCP servers into ~/.claude.json
Read `<repo>/claude-code/mcp-servers.json` and merge its contents into `~/.claude.json` under the `mcpServers` key. Do NOT overwrite other fields in `.claude.json` — only add/update the `mcpServers` section.

### 6. Restart Claude Code
Tell the user to restart Claude Code so MCP servers take effect.

## Important Notes
- NEVER copy `.credentials.json` — it contains auth tokens unique to each machine
- NEVER copy `cache/`, `debug/`, `shell-snapshots/`, `stats-cache.json` — these are machine-local
- If `~/.claude/` doesn't exist, create it first
- If files already exist at the destination, overwrite them (repo is the source of truth)
- After setup, the GLOBAL_CLAUDE.md will contain sync-back instructions so future changes are pushed back to this repo
