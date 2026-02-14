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
├── codex/                ← Codex 설정 (TBD)
└── antigravity/          ← Antigravity 설정 (TBD)
```

## Usage

### New Machine Setup
에이전트에게 이 repo URL을 전달하면, 각 에이전트 폴더의 SETUP.md를 따라 자동 세팅합니다.

```
https://github.com/payolajoker/ai-agent-setting.git
```

### Sync
로컬에서 글로벌 설정이 변경되면, 에이전트가 자동으로 이 repo에 push합니다.
