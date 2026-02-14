# Codex Global Settings Sync

This file is managed via the **ai-agent-setting** repository for Codex.

- Repo: https://github.com/payolajoker/ai-agent-setting.git
- Path: `codex/GLOBAL_CODEX.md`

## Sync Rules

When ANY of the following global settings are added or changed locally, you MUST push the changes to the repo:

- `~/.codex/config.toml` → sync to `codex/config.toml`
- `~/.codex/skills/` (new skill added) → sync to `codex/skills/`

### How to sync

1. Clone or pull the repo: `git clone https://github.com/payolajoker/ai-agent-setting.git` (or `git pull` if already cloned)
2. Copy the changed files into `codex/`
3. Commit and push with a clear message describing what changed

## Important

- The repo is shared with other agents (Codex, Antigravity, Claude). Only touch the `codex/` folder.
- NEVER commit `.credentials.json`, `.personality_migration`, `auth.json`, `cap_sid`, `cache/`, `debug/`, `stats-cache.json`, `shell-snapshots/`, `sessions/`, or `tmp/`

## Setup Trigger

If the user provides the repo URL (`https://github.com/payolajoker/ai-agent-setting.git`) and asks to set up Codex, follow `codex/SETUP.md` in the repo.
