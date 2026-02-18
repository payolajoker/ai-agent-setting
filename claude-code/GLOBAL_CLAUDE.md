# Discord Webhook

When the user says "디스코드 보내" or "디스코드에 공유", send the recent conversation content to this webhook.

- Webhook URL: https://discord.com/api/webhooks/1471966887633223823/jFOrPRxby6_BiWcBhuy1kXxJiT9R-2jNOn7U-UDVKZvaN8i2kYs93DStidW3GikzZPdo
- Username: 꿀꿀로드
- Format: Discord Embed with cyan color (65535), fields for User/Claude, footer with project name
- 전송 시 반드시 `User-Agent: DiscordBot (https://github.com/payolajoker, 1.0)` 헤더를 포함할 것 (미포함 시 Cloudflare가 403으로 차단함)

# Codex CLI 위임 규칙

Claude의 **5시간 세션 사용량(utilization) > 30%** 이면 작업을 Codex CLI에 위임한다.

## 위임 절차 (반드시 이 순서로 실행)

1. **사용량 확인**: 작업 요청이 들어오면 먼저 Bash 도구로 확인
   ```bash
   python -c "
   import json, urllib.request
   from pathlib import Path
   cred = json.load(open(Path.home() / '.claude/.credentials.json'))
   token = cred['claudeAiOauth']['accessToken']
   req = urllib.request.Request('https://api.anthropic.com/api/oauth/usage', headers={'Authorization': f'Bearer {token}', 'anthropic-beta': 'oauth-2025-04-20'})
   data = json.loads(urllib.request.urlopen(req, timeout=5).read())
   print(data.get('five_hour', {}).get('utilization', 0))
   "
   ```

2. **위임 판단**:
   - utilization ≤ 30 → Claude가 직접 처리
   - utilization > 30 → 아래 래퍼 스크립트로 Codex에 위임

3. **Codex 위임 실행**: Bash 도구로 아래 명령을 실행
   ```bash
   python "C:/Users/User/.claude/dashboard/codex_delegate.py" "태스크 설명" "작업디렉터리(선택)"
   ```
   - 스크립트가 사용량 재확인 → Codex exec 실행 → 최종 응답 출력
   - 출력된 [Codex 최종 응답] 섹션 내용을 사용자에게 전달

4. **Codex도 여유 없을 때**: Codex `primary.used_percent > 80` 이면 사용자에게 양쪽 사용량 부족 알림

## Codex 사용량 확인 방법

```bash
python -c "
import glob, json, os
from pathlib import Path
files = sorted(glob.glob(str(Path.home()/'.codex/sessions/**/*.jsonl'), recursive=True), key=os.path.getmtime, reverse=True)
rl = None
for line in open(files[0], encoding='utf-8'):
    d = json.loads(line)
    if d.get('type')=='event_msg' and d.get('payload',{}).get('type')=='token_count' and d.get('payload',{}).get('rate_limits'):
        rl = d['payload']['rate_limits']
print('primary:', rl['primary']['used_percent'], '%')
"
```

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
