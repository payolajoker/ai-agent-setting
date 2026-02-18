# Discord Webhook

When the user says "디스코드 보내" or "디스코드에 공유", send the recent conversation content to this webhook.

- Webhook URL: https://discord.com/api/webhooks/1471966887633223823/jFOrPRxby6_BiWcBhuy1kXxJiT9R-2jNOn7U-UDVKZvaN8i2kYs93DStidW3GikzZPdo
- Username: 꿀꿀로드
- Format: Discord Embed with cyan color (65535), fields for User/Claude, footer with project name
- 전송 시 반드시 `User-Agent: DiscordBot (https://github.com/payolajoker, 1.0)` 헤더를 포함할 것 (미포함 시 Cloudflare가 403으로 차단함)

# Codex CLI 위임 규칙

코드 작성, 분석, 리팩토링 등의 작업 요청이 들어올 때, Claude의 **5시간 세션 잔여 사용량이 70% 미만**인 경우 `codex exec` 명령을 통해 Codex CLI에 작업을 위임한다.

- 위임 명령: `codex exec -s workspace-write -a never "프롬프트"`
- 결과는 Codex CLI 출력을 받아 사용자에게 정리해서 전달한다
- 잔여 사용량이 70% 이상이면 Claude가 직접 처리한다

## 사용량 자동 확인 방법

작업 요청 시 아래 방법으로 사용량을 자동으로 확인한다:

1. 토큰 읽기: `~/.claude/.credentials.json` → `claudeAiOauth.accessToken`
2. API 호출:
   - Endpoint: `https://api.anthropic.com/api/oauth/usage`
   - Headers: `Authorization: Bearer {accessToken}`, `anthropic-beta: oauth-2025-04-20`
   - Method: GET
3. 응답 해석:
   - `five_hour.utilization` → 5시간 세션 사용률 (%)
   - `seven_day.utilization` → 7일 주간 사용률 (%)
   - 잔여량 = 100 - utilization
4. 판단 기준: `five_hour.utilization > 30` (잔여 70% 미만) → Codex CLI 위임

## Codex CLI 사용량 확인 방법

Codex로 위임하기 전, Codex 사용량도 확인한다:

1. 최근 세션 파일 읽기: `~/.codex/sessions/**/*.jsonl` 중 가장 최근 파일
2. `type == "event_msg"` && `payload.type == "token_count"` && `payload.rate_limits` 이벤트 찾기
3. 응답 해석:
   - `rate_limits.primary.used_percent` → 5시간 세션 사용률 (%)
   - `rate_limits.secondary.used_percent` → 7일 주간 사용률 (%)
   - `rate_limits.primary.resets_at` → Unix timestamp (리셋 시각)
4. 판단 기준: `primary.used_percent > 80` (잔여 20% 미만) → Codex도 여유 없음, 사용자에게 알림

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
