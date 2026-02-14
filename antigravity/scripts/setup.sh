#!/bin/bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
GEMINI_DIR="$HOME/.gemini"
SKILLS_DIR="$GEMINI_DIR/skills"

echo "Setting up Antigravity (Gemini) environment..."

# 1. Create directories
mkdir -p "$GEMINI_DIR"
mkdir -p "$SKILLS_DIR"

# 2. Copy GLOBAL_GEMINI.md -> GEMINI.md
cp "$REPO_ROOT/antigravity/GLOBAL_GEMINI.md" "$GEMINI_DIR/GEMINI.md"
echo "Copied configuration to $GEMINI_DIR/GEMINI.md"

# 3. Copy Skills
cp -r "$REPO_ROOT/antigravity/skills/"* "$SKILLS_DIR/"
echo "Copied skills to $SKILLS_DIR"

echo "✅ Antigravity setup complete!"
