# Execution Strategy Reference

## Strategy Comparison

| Strategy | Token Cost | Wall-Clock Time | Best For |
|----------|-----------|-----------------|----------|
| Sequential | 1x | Longest | ≤5 tasks, tightly coupled, budget-conscious |
| Selective parallelism | 2-3x | Medium | 6-12 tasks, some independent groups |
| Full parallelism | 3-5x | Shortest | 12+ tasks, clear file boundaries |
| Agent Team | 5-8x | Medium-Short | Workers need debate, challenge, coordination |

## Sequential Execution
Execute each task one by one in the main context. Simplest approach.
Use when tasks are tightly coupled or there are very few tasks.

Advantages: lowest token cost, simplest to debug, no coordination overhead
Disadvantages: slowest wall-clock time, context grows with each task

## Subagent Execution (Selective / Full Parallelism)
Spawn independent tasks as subagents via the Task tool.

Key rules:
- Each subagent gets a SELF-CONTAINED prompt (they don't see your conversation)
- File ownership is absolute: never assign the same file to two concurrent subagents
- Use foreground execution (default). run_in_background has known file-write issues.
- Subagents CANNOT spawn other subagents (no nesting)
- Max ~10 concurrent subagents
- After each parallel group completes, verify integration before next group

Prompt quality checklist:
- [ ] Exact file paths included
- [ ] Complete behavioral spec (not "add validation" but specific rules)
- [ ] Verification command included
- [ ] Project conventions referenced (CLAUDE.md)
- [ ] Files owned by this subagent explicitly listed
- [ ] Files NOT to touch explicitly stated

## Agent Team Execution
For tasks requiring real inter-agent communication.

Prerequisites:
- CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 must be set
- Tasks must genuinely benefit from agent communication

Setup:
1. Describe team structure in natural language
2. Activate delegate mode (Shift+Tab) — lead coordinates only
3. Create tasks on shared task list (5-6 per teammate)
4. Set task dependencies with addBlockedBy
5. Monitor with Ctrl+T (tasks) and Shift+Up/Down (teammates)

Team patterns (see team-patterns.md for details):
- Research Board: parallel investigation → cross-review → synthesis
- Module Owners: each teammate owns separate files with interface contracts
- Hypothesis Race: competing theories with disconfirming evidence
- Layer Specialists: frontend/backend/testing separation
- Red/Blue Team: adversarial build→attack→defend cycles

Known limitations:
- No session resumption (teammates lost on /resume)
- One team per session
- No nested teams (teammates can't spawn teams)
- Fixed lead (can't transfer leadership)
- Teammates don't inherit lead's conversation history

## Decision Flowchart

    Can one agent handle this in <10 min without context overflow?
      → YES: Sequential. No parallelism needed.
      → NO: Continue...

    Are there 2+ independent tasks that don't need to talk to each other?
      → YES: Subagents (selective or full parallelism)
      → NO: Continue...

    Do workers need to share findings, debate, or coordinate in real time?
      → YES: Agent Team
      → NO: Re-examine — probably sequential with careful ordering
