#!/bin/bash
# BPE Plugin — Session Start Hook
# Outputs a brief reminder that BPE skills are available

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cat << 'EOF'
<bpe-available>
BPE (Brainstorm → Plan → Execute) is available. When the user describes
a development task, consider whether it would benefit from structured
requirements gathering before implementation. Available commands:
/bpe:brainstorm, /bpe:plan, /bpe:execute.
Skills auto-trigger based on context.
</bpe-available>
EOF
