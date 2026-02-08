---
name: smart-execute
description: >-
  Use AFTER a plan with task list exists and the user has approved execution.
  Activates when user says "execute", "go", "start building", "implement the
  plan", or when transitioning from smart-plan. Also use when user says
  /bpe:execute.
---

# Phase 3: Smart Execute — Intelligent Implementation

You are an implementation coordinator. Your job is to execute the approved plan
using the optimal strategy, with verification at every step.

**Read `references/execution-strategy.md` now before proceeding.**

## Process

### Step 1: Load Plan and Tasks
Read the plan from `docs/plans/{feature-name}.md`.
Load the task list via TaskList.
Confirm the execution strategy from the plan.

### Step 2: Execute by Strategy

#### Strategy: Sequential (main context)
For each task in dependency order:
1. **Claim**: TaskUpdate(taskId, status: "in_progress")
2. **Announce**: State what you're building and which files you'll touch
3. **Build**: Write code following project conventions from CLAUDE.md
4. **Verify**: Run the task's verification command
5. **Complete**: TaskUpdate(taskId, status: "completed")

#### Strategy: Selective / Full Parallelism (subagents)
For each parallel group:
1. Spawn subagents via the Task tool, one per independent task or group
2. Each subagent gets a self-contained prompt (see prompt template below)
3. After the group completes, run integration verification
4. Move to the next dependency group

Subagent prompt template:

    Task(
      description: "Implement: {task subject}",
      prompt: "You are implementing a specific task.

        ## Your Task
        {full task description from TaskCreate}

        ## Design Context
        {paste relevant sections from design doc — only what this subagent needs}

        ## Constraints
        - ONLY modify these files: {explicit list}
        - Follow project conventions (see CLAUDE.md)
        - Run this verification when done: {command}
        - Report: files changed, tests passing/failing, any issues

        ## Working Directory
        {cwd}"
    )

Subagent rules:
- Each subagent owns specific files. NEVER assign the same file to two concurrent subagents.
- Include all necessary context in the prompt. Subagents do NOT see conversation history.
- Have each subagent verify its own work before returning.
- Use foreground execution (default). run_in_background has known file-write reliability issues.
- Subagents CANNOT spawn other subagents. If a task is too complex, break it down further.

For custom subagent roles, use the bundled agents:
- `bpe:researcher` — codebase investigation, read-only
- `bpe:builder` — implementation with write access
- `bpe:reviewer` — code review, read-only

#### Strategy: Agent Team
Read `references/team-patterns.md` for detailed team patterns.

1. Remind user to verify CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 is set
2. Describe the team in natural language to Claude Code:

        Create an agent team:
        - [Role 1]: [responsibility, owned files, what "done" means]
        - [Role 2]: [responsibility, owned files, what "done" means]
        Rules:
        - Each teammate owns different files
        - Use delegate mode (lead coordinates, doesn't implement)
        - 5-6 tasks per teammate

3. Activate delegate mode (Shift+Tab) to keep lead as coordinator
4. For risky tasks, require plan approval before implementation
5. Monitor progress (Ctrl+T for tasks, Shift+Up/Down for teammates)

### Step 3: Post-Group Verification
After each parallel group or sequential batch completes:
- Run integration tests across all changed files
- Check for interface mismatches
- Resolve any conflicts before the next group

### Step 4: Final Verification
After ALL tasks are complete:
1. Run the FULL test suite
2. Run linter and formatter
3. Run type checker if applicable
4. Check every success criterion from the design document
5. Report summary:

        ## Execution Summary
        ### Changes
        - N files created, M files modified
        - N tests added, all passing

        ### Success Criteria
        - [x] Criterion 1: verified by {how}
        - [x] Criterion 2: verified by {how}
        - [ ] Criterion 3: partially done — {reason and next steps}

        ### Deviations from Plan
        - Any changes made during execution and why

### Step 5: Update Learning Memory
After delivering results, update memory:

**Auto memory** (tell Claude "remember this"):
- Patterns that worked well in this session
- Gotchas discovered about the codebase
- Effective team compositions for this type of task

**Project CLAUDE.md** (./.claude/CLAUDE.md) — only if errors occurred:
- Add to a `## BPE Learning Log` section
- Record agent errors with root cause and prevention
- Record human instruction issues with handling
- Keep entries specific and actionable

**User CLAUDE.md** (~/.claude/CLAUDE.md) — only for universal lessons:
- Promote lessons that prove useful across 2+ projects
- Keep it concise, under 50 lines for BPE content

The Second-Time Rule: if the same type of error occurs twice, it becomes
a mandatory active prevention in project CLAUDE.md.

## Recovery Patterns

**Test failure**: Read error, fix, re-run (max 2 attempts). If stuck, mark task with note and move on.
**Context growing long**: Summarize completed work, spawn subagents for remaining independent tasks.
**Plan needs adjustment**: Pause, explain discovery, propose changes, wait for user approval.
**Subagent returns error**: Check the error, fix the prompt or task scope, re-spawn.
