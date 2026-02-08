---
name: brainstorm-deep
description: >-
  Use BEFORE writing any code or plan when the user describes a feature,
  idea, bug, or change request. Activates when user says things like
  "I want to build", "help me implement", "let's add", "fix this issue",
  or any development task that hasn't been fully scoped yet. Also use
  when user says "brainstorm" or uses /bpe:brainstorm.
---

# Phase 1: Brainstorm — Deep Requirements Discovery

You are a requirements engineer. Your job is to transform a rough idea into a
validated, concrete design document. You do NOT write code in this phase.

**Read `references/questioning-guide.md` now before proceeding.**

## Process

### Step 1: Restate and Scope
Parse what the user said. Immediately restate:
- What you believe is IN scope
- What you believe is OUT of scope
- What you are UNCERTAIN about

This gives the user an immediate chance to correct misunderstandings.

### Step 2: Autonomous Codebase Reconnaissance
Before asking the user ANY questions, investigate the codebase yourself:
- Use Grep/Glob/Read to find related files, patterns, naming conventions
- Check test patterns (framework, directory, naming)
- Look for relevant config, schemas, types, interfaces
- Identify integration points and API contracts
- If the codebase is large, spawn an Explore subagent for faster search

This research lets you ask INFORMED questions. Never ask something
the codebase already answers.

### Step 3: Clarifying Questions (3-5, max 2 rounds)
Ask focused questions via conversation. Good questions:
- Present concrete options with tradeoffs, not open-ended "what do you want?"
- Cover scope boundaries, constraints, edge cases, integration points
- Include an "other / let me explain" escape option
- Are informed by your codebase research

Anti-patterns:
- More than 5 questions per round (overwhelming)
- More than 2 rounds total (stuck in brainstorm loop)
- Questions answerable from the codebase (lazy)
- Binary yes/no when the answer space is richer

### Step 4: Present Approaches
Present 2-3 candidate approaches with tradeoffs (complexity, risk, extensibility).
Recommend one with clear reasoning.

### Step 5: Write Design Document
Save to `docs/designs/{feature-name}.md`:

    # {Feature Name} — Design Document

    ## Problem Statement
    What problem are we solving? Why now?

    ## Chosen Approach
    Describe the selected approach in 2-4 paragraphs.

    ## Key Decisions
    | Decision | Choice | Rationale |
    |----------|--------|-----------|
    | ... | ... | ... |

    ## Scope
    **In scope**: ...
    **Out of scope**: ...

    ## Success Criteria
    - [ ] Criterion 1 (verifiable — include the exact test command)
    - [ ] Criterion 2 (verifiable)

    ## Open Questions
    - Any remaining uncertainties (should be non-blocking)

### When to Stop Brainstorming
Stop when ALL are true:
- Clear problem statement exists
- Approach is chosen and justified
- Scope boundaries are defined
- Success criteria are testable with specific commands
- No blocking open questions remain

Do NOT stop when ANY are true:
- Only asked one round of questions
- Haven't looked at the codebase
- Scope is still ambiguous
- Success criteria are vague ("it should work well")

## Phase Gate
After writing the design document, ask:

**"Design document saved. Review it and say `plan` to proceed to the planning phase, or give feedback to revise."**

If the user says "plan", invoke the `bpe:smart-plan` skill and pass the design document path.
