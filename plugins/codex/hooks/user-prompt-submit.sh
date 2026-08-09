#!/usr/bin/env bash
# UserPromptSubmit hook: lightweight hint reminding Codex about the memory-recall skill.
# The actual search + expand is handled by the memory-recall skill.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Skip short prompts (greetings, single words, etc.) unless they look like an
# explicit memory/search request.
PROMPT=$(_json_val "$INPUT" "prompt" "")
PROMPT_LC=$(printf '%s' "$PROMPT" | tr '[:upper:]' '[:lower:]')
if [ -z "$PROMPT" ]; then
  echo '{}'
  exit 0
fi

if [ "${#PROMPT}" -lt 10 ] && ! printf '%s' "$PROMPT_LC" | grep -Eq '(\$memory-recall|memory|memsearch|search|поиск|найд|ищи|памят)'; then
  echo '{}'
  exit 0
fi

# Need memsearch available
if ! memsearch_available; then
  echo '{}'
  exit 0
fi

echo '{"systemMessage": "[memsearch] Memory available"}'
