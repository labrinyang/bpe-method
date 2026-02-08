---
name: smart-plan
description: >-
  Use AFTER requirements are validated (design document exists) and BEFORE
  any implementation begins. Activates when user says "plan", "write a plan",
  "break this down", or when transitioning from brainstorm-deep. Also use
  when user says /bpe:plan.
---

# Phase 2: Smart Plan — Dependency-Aware Task Decomposition

You are a technical architect. Your job is to break the approved design into
an ordered, dependency-aware task list with an explicit execution strategy.

**Read `references/decomposition-guide.md` now before proceeding.**

## Process

### Step 1: Load Design Document
Read the design document from Phase 1 (usually at `docs/designs/{feature-name}.md`).
If $ARGUMENTS contains a path, use that. If not, ask the user or search `docs/designs/`.

### Step 2: Decompose into Tasks
Break the design into discrete tasks. Each task must have:
1. **What**: The specific deliverable (file, function, test, config)
2. **Where**: Exact file paths to create or modify
3. **Acceptance**: The exact verification command and expected output
4. **Context**: References to design document sections if needed

Right-sizing:
- Too small (< 1 min): "Add import statement" → merge with adjacent tasks
- Too large (> 10 min): "Implement entire auth system" → split further
- Right size (2-5 min): "Create JWT validation middleware with tests"

### Step 3: Map Dependencies
For each task:
- If Task B reads a file Task A creates → B depends on A
- If Task B imports a module Task A defines → B depends on A
- If Task B tests code Task A writes → B depends on A
- If two tasks touch different files with no shared interface → independent

### Step 4: Create Task List
Use TaskCreate for every task:

    TaskCreate(
      subject: "Create JWT validation middleware",
      description: "Create src/middleware/auth.ts exporting validateJWT().
        Must handle expired tokens, invalid signatures, missing tokens.
        Files: src/middleware/auth.ts, src/middleware/__tests__/auth.test.ts
        Verify: npm test -- --testPathPattern auth.test.ts",
      activeForm: "Creating JWT validation middleware"
    )

Set dependencies:

    TaskUpdate(taskId: "3", addBlockedBy: ["1", "2"])

### Step 5: Choose Execution Strategy

Based on task count, coupling, and complexity:

| Condition | Strategy | How |
|-----------|----------|-----|
| ≤ 5 tasks OR tightly coupled | **Sequential** | Execute all in main context, one by one |
| 6-12 tasks, some independent groups | **Selective parallelism** | Independent groups via Task tool (subagents), sequential groups in main context |
| 12+ tasks, clear file ownership | **Full parallelism** | Every independent group gets subagent(s) |
| Workers need to debate / challenge / coordinate | **Agent Team** | Enable CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS, use delegate mode |

Write strategy recommendation with reasoning.

### Step 6: Write Plan Summary
Save to `docs/plans/{feature-name}.md`:

    # {Feature Name} — Implementation Plan

    ## Execution Strategy
    [Sequential / Selective Parallelism / Full Parallelism / Agent Team]
    Reasoning: [why this strategy]

    ## Task Graph
    1. [Foundation] Create types and interfaces
    2. [Foundation] Set up test fixtures
    3. [Core] Implement main logic (blocked by 1)
    4. [Core] Implement secondary logic (blocked by 1)
    5. [Integration] Wire up API endpoint (blocked by 3, 4)
    6. [Verification] Integration tests (blocked by 5)

    ## Parallel Groups
    - Group A (independent): Tasks 1, 2
    - Group B (after A): Tasks 3, 4
    - Group C (after B): Task 5
    - Group D (after C): Task 6

    ## File Ownership (if using parallelism)
    | Worker | Owned Files |
    |--------|-------------|
    | Subagent/Teammate 1 | src/types.ts, src/config.ts |
    | Subagent/Teammate 2 | src/auth.ts, src/auth.test.ts |

    ## Risk Notes
    - [Highest-uncertainty task and why]
    - [Any tasks that touch shared state]

## Phase Gate
After creating the task list and plan, ask:

**"Plan created with N tasks (strategy: [strategy]). Toggle the task list with Ctrl+T. Say `execute` to start implementation, or give feedback to revise."**

If the user says "execute", invoke the `bpe:smart-execute` skill and pass the plan path.
