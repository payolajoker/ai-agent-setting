# AI Agent Settings

AI 에이전트별 글로벌 설정을 관리하는 저장소.
새 PC에서 에이전트를 세팅할 때, 이 repo URL만 전달하면 자동으로 글로벌 설정을 적용합니다.

## Structure

```
ai-agent-setting/
├── claude-code/          ← Claude Code 설정
│   ├── GLOBAL_CLAUDE.md  ← 글로벌 지시사항 (→ ~/.claude/CLAUDE.md)
│   ├── settings.json     ← 권한 설정 (→ ~/.claude/settings.json)
│   ├── mcp-servers.json  ← MCP 서버 설정 (→ ~/.claude.json mcpServers)
│   ├── skills/           ← 스킬 (→ ~/.claude/skills/)
│   └── SETUP.md          ← 새 PC 세팅 매뉴얼
├── codex/                ← Codex 설정
│   ├── GLOBAL_CODEX.md    ← 글로벌 지시사항 (→ ~/.codex/GLOBAL_CODEX.md)
│   ├── config.toml        ← Codex 설정 파일 (→ ~/.codex/config.toml)
│   ├── skills/            ← 스킬 (→ ~/.codex/skills/)
│   └── SETUP.md           ← 새 PC 세팅 매뉴얼
└── antigravity/          ← Antigravity (Gemini) 설정
    ├── GLOBAL_GEMINI.md   ← 글로벌 지시사항 (→ ~/.gemini/GEMINI.md)
    ├── skills/            ← 스킬 (→ ~/.gemini/skills/)
    ├── scripts/           ← 자동 세팅 스크립트
    └── SETUP.md           ← 새 PC 세팅 매뉴얼
```

## Usage

### New Machine Setup
에이전트에게 이 repo URL을 전달하면, 각 에이전트 폴더의 SETUP.md를 따라 자동 세팅합니다.

```
https://github.com/payolajoker/ai-agent-setting.git
```

#### Antigravity (Gemini)
```powershell
# Windows
pwsh ./antigravity/scripts/setup.ps1
```

### Sync
- 로컬에서 글로벌 설정이 변경되면, 에이전트가 자동으로 이 repo에 push합니다.
- Codex MCP는 `~/.codex/config.toml` 기준으로 동기화되며, `~/.claude.json`(mcpServers) 또는 `~/.claude/mcp-servers.json`에 있던 MCP도 포함해 반영합니다.
- Codex는 `ai-agent-setting/codex/scripts/sync-codex.ps1`로 동기화할 수 있습니다:
  ```powershell
  cd ai-agent-setting
  pwsh ./codex/scripts/sync-codex.ps1
  ``` 

