#!/usr/bin/env bash
# scripts/enable-hooks.sh
set -euo pipefail
mkdir -p .githooks
cat > .githooks/pre-commit <<'SH'
#!/usr/bin/env bash
branch="$(git rev-parse --abbrev-ref HEAD)"
if [ "$branch" = "main" ]; then
  echo "[WARN] You are committing on 'main'. Prefer 'work/active' or 'task/*' branches."
fi
SH
cat > .githooks/pre-push <<'SH'
#!/usr/bin/env bash
branch="$(git rev-parse --abbrev-ref HEAD)"
if [ "$branch" = "main" ]; then
  echo "[WARN] You are pushing 'main'. This is allowed for the owner."
fi
SH
chmod +x .githooks/pre-commit .githooks/pre-push
git config core.hooksPath .githooks
echo "Hooks installed."
