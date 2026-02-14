# Discord Webhook

When the user says "디스코드 보내" or "디스코드에 공유", send the recent conversation content to this webhook.

- Webhook URL: https://discord.com/api/webhooks/1471966887633223823/jFOrPRxby6_BiWcBhuy1kXxJiT9R-2jNOn7U-UDVKZvaN8i2kYs93DStidW3GikzZPdo
- Username: 꿀꿀로드
- Format: Discord Embed with cyan color (65535), fields for User/Claude, footer with project name

# Global Settings Sync

This file is managed via the **ai-agent-setting** repository.

- Repo: https://github.com/payolajoker/ai-agent-setting.git
- Path: `claude-code/GLOBAL_CLAUDE.md`

## Sync Rules

When ANY of the following global settings are added or changed locally, you MUST push the changes to the repo:

- `~/.claude/CLAUDE.md` → sync to `claude-code/GLOBAL_CLAUDE.md`
- `~/.claude/settings.json` → sync to `claude-code/settings.json`
- `~/.claude/skills/` (new skill added) → sync to `claude-code/skills/`
- `~/.claude.json` mcpServers section → sync to `claude-code/mcp-servers.json`

### How to sync

1. Clone or pull the repo: `git clone https://github.com/payolajoker/ai-agent-setting.git` (or `git pull` if already cloned)
2. Copy the changed files into `claude-code/`
3. Commit and push with a clear message describing what changed

### Important

- The repo is shared with other agents (Codex, Antigravity). Only touch the `claude-code/` folder.
- NEVER commit `.credentials.json`, `cache/`, `debug/`, `stats-cache.json`, or `shell-snapshots/`

## New Machine Setup

If the user provides the repo URL (`https://github.com/payolajoker/ai-agent-setting.git`) and asks to set up, follow `claude-code/SETUP.md` in the repo.
