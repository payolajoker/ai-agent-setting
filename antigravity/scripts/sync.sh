#!/bin/bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
GEMINI_DIR="$HOME/.gemini"
SKILLS_DIR="$GEMINI_DIR/skills"

echo "Syncing Antigravity (Gemini) settings to repo..."

# 1. Pull latest changes
cd "$REPO_ROOT"
git pull

# 2. Sync GLOBAL_GEMINI.md
if [ -f "$GEMINI_DIR/GEMINI.md" ]; then
    cp "$GEMINI_DIR/GEMINI.md" "$REPO_ROOT/antigravity/GLOBAL_GEMINI.md"
    echo "Synced: $GEMINI_DIR/GEMINI.md -> antigravity/GLOBAL_GEMINI.md"
else
    echo "Warning: Local config not found at $GEMINI_DIR/GEMINI.md"
fi

# 3. Sync Skills
if [ -d "$SKILLS_DIR" ]; then
    mkdir -p "$REPO_ROOT/antigravity/skills"
    cp -r "$SKILLS_DIR/"* "$REPO_ROOT/antigravity/skills/"
    echo "Synced skills from $SKILLS_DIR"
else
    echo "Warning: Local skills not found at $SKILLS_DIR"
fi

# 4. Git Status & Push
if [[ `git status --porcelain` ]]; then
    echo "Changes detected. Pushing to remote..."
    git add .
    git commit -m "Sync Antigravity settings from local machine"
    git push
    echo "✅ Sync complete!"
else
    echo "✅ No changes to sync."
fi
