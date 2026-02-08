# Task Decomposition Guide

## Principles

### Write Tasks for a Context-Free Agent
Subagents and teammates do NOT see the lead's conversation history.
Every task description must be self-contained:
- Exact file paths (not "the auth file" but "src/middleware/auth.ts")
- Complete behavioral spec (not "add validation" but "reject tokens older than 24h, return 401 with { error: 'TOKEN_EXPIRED' }")
- The verification command and expected output

### Identify Parallel Groups
Tasks are independent when they:
- Touch completely different files
- Have no import or dependency relationships
- Can be verified independently

Common parallel patterns:
- Multiple independent utility functions or modules
- Frontend component + backend endpoint (when interface is defined by a prior task)
- Multiple independent test files
- Documentation alongside implementation (when docs are standalone)

### File Ownership is Absolute
If using parallelism (subagents or agent teams), each worker must own specific files.
Two workers editing the same file → last-write-wins → data loss.

If two tasks MUST touch the same file:
- Sequence them (task B depends on task A)
- Or combine them into one task

### Task Dependencies Form a DAG
Use TaskUpdate with addBlockedBy to express dependencies.
A task with unresolved blockedBy entries cannot be claimed.

    TaskUpdate(taskId: "5", addBlockedBy: ["3", "4"])

This means Task 5 waits for both 3 and 4 to complete.

### Execution Strategy Decision Matrix

| Signal | Points toward |
|--------|--------------|
| Tasks share many files | Sequential |
| Clear independent groups exist | Selective parallelism |
| 12+ tasks with clear file boundaries | Full parallelism |
| Workers need to debate or cross-review | Agent Team |
| Single hypothesis, straightforward | Sequential |
| Competing hypotheses, need disproval | Agent Team |
| Token budget is tight | Sequential (lowest cost) |
| Wall-clock time is critical | Full parallelism (highest cost) |

### Agent Team Decision Criteria
Only recommend agent teams when ALL of:
1. Workers genuinely need to communicate with each other (not just return results)
2. The task benefits from debate, challenge, or sustained coordination
3. The token cost (5-8x vs solo) is justified by the value of collaboration
4. CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 is set (remind user if not)

Common agent team patterns:
- Competing-hypothesis debugging (investigators disprove each other)
- Parallel code review from multiple angles (security, performance, correctness)
- Multi-module feature build with interface contracts
- Adversarial review (red team / blue team)
