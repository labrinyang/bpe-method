# BPE — Brainstorm → Plan → Execute

A Claude Code plugin that enforces structured 3-phase development:

1. **Brainstorm** — Deep requirements discovery with codebase research
2. **Plan** — Dependency-aware task decomposition with execution strategy
3. **Execute** — Intelligent implementation (solo / subagent / agent team)

## Installation

```bash
# Step 1: Add marketplace
/plugin marketplace add labrinyang/bpe-method

# Step 2: Install plugin
/plugin install bpe@bpe-marketplace
```
## Usage

### Automatic
Just describe what you want to build. BPE skills trigger automatically.

### Manual Commands
- `/bpe:brainstorm` — Start requirements discovery
- `/bpe:plan` — Create implementation plan
- `/bpe:execute` — Execute the plan

## Phase Gates
Each phase requires explicit user approval to proceed:
- After brainstorm: say "plan" to move to planning
- After plan: say "execute" to start implementation

## Components

### Skills (auto-triggered)
- `brainstorm-deep` — Requirements engineering
- `smart-plan` — Task decomposition and strategy selection
- `smart-execute` — Implementation coordination

### Agents (spawned during execution)
- `researcher` — Codebase investigation (read-only)
- `builder` — Task implementation (read-write)
- `reviewer` — Code review (read-only)

### Commands (user-invoked)
- `/bpe:brainstorm`, `/bpe:plan`, `/bpe:execute`

## Works with Superpowers
BPE is designed to complement the Superpowers plugin. Install both:
- Superpowers provides TDD, debugging, git worktrees, code review methodology
- BPE provides structured brainstorm → plan → execute workflow
- During execution, BPE can invoke Superpowers skills like
  `superpowers:test-driven-development`

## Memory & Learning
BPE uses Claude Code's native memory system:
- Auto memory for patterns and discoveries
- Project CLAUDE.md for project-specific error logs
- User CLAUDE.md for universal methodology (promoted after 2+ projects)
