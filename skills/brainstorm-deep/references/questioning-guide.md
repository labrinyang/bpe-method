# Questioning Guide for Deep Requirements Discovery

## Philosophy
The goal is to reach a concrete, implementable design in 2 rounds of questions
maximum. Each question should eliminate ambiguity, not create it.

## Question Categories

### 1. Scope Boundaries
- "Should this handle [edge case X], or is that out of scope for now?"
- "Is this a standalone feature, or does it need to integrate with [system Y]?"
- "What's the minimal version that would be useful?"

### 2. Constraints
- "Are there performance requirements? (e.g., must respond in < 200ms)"
- "Does this need to support [backward compatibility / migration]?"
- "Are there security considerations I should know about?"

### 3. User-Facing Behavior
- "When [trigger event], what should the user see?"
- "What happens when [error condition]?"
- "Should there be [configuration / hardcoded defaults]?"

### 4. Integration Points
- "Which existing modules does this touch?"
- "Does this require changes to the database schema?"
- "Are there external APIs or services involved?"

## Question Framing Best Practices

### Present Options, Not Open Questions
Bad: "How should we handle authentication?"
Good: "For authentication, I see two options:
  A) Use the existing JWT middleware (simpler, but limited to current scopes)
  B) Add OAuth2 support (more work, but enables third-party integrations)
  Which fits your needs better, or is there another approach?"

### Include Evidence from Codebase Research
Bad: "What test framework do you use?"
Good: "I see you're using Jest with the convention `__tests__/*.test.ts`.
  I'll follow that pattern. Any exceptions I should know about?"

### Anchor Questions to Discovered Context
Bad: "What's the API format?"
Good: "Your existing endpoints in `src/routes/` return `{ data, error, meta }`.
  Should this new endpoint follow the same contract?"

## Escape Hatch
If the user seems frustrated with questions or says "just do it":
- Summarize your best understanding of the requirements
- List your assumptions explicitly
- Ask: "I'll proceed with these assumptions. Correct me if anything is off."
- Move to the design document

## Round Budget
- Round 1: 3-5 questions covering the highest-risk unknowns
- Round 2: 0-3 follow-up questions only if Round 1 revealed new ambiguity
- If still unclear after Round 2: state assumptions and move forward
