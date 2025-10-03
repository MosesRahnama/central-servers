#!/usr/bin/env bash
# scripts/bootstrap-repo.sh
set -euo pipefail

mkdir -p infra/cloudrun scripts .github/workflows .githooks docs logs .vscode .cursor/rules

[ -f .vscode/settings.json ] || cat > .vscode/settings.json <<'JSON'
{ "editor.formatOnSave": true, "git.enableSmartCommit": true }
JSON

[ -f .cursor/rules/repo-guard.mdc ] || mkdir -p .cursor/rules && cat > .cursor/rules/repo-guard.mdc <<'MDC'
# Repo Rules
- Branches: use work/active or task/*; avoid main.
MDC

bash scripts/enable-hooks.sh
git add .
git commit -m "chore: bootstrap folders, hooks, settings"
