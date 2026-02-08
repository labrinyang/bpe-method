# Team Patterns Reference

## 1. Research Board
**Purpose**: Multiple aspects need investigation with cross-examination.
**Default**: Subagents (independent research paths)
**Upgrade to Agent Team**: When researchers need to challenge each other's findings

Subagent version:
- Spawn 2-4 researcher subagents, each investigating a different angle
- Main context synthesizes findings, identifies contradictions
- Spawn tiebreaker subagent if contradictions found

Agent Team version:
- Teammates investigate, then review and challenge each other via messaging
- Lead synthesizes validated results

## 2. Module Owners
**Purpose**: Building multiple independent modules that integrate.
**Mechanism**: Agent Team (teammates need file coordination)

Critical rules:
- Define interface contracts BEFORE building starts
- Each owner touches ONLY their assigned files
- Use stubs/mocks for cross-module dependencies
- Integration testing after all modules complete

## 3. Hypothesis Race
**Purpose**: Debugging with multiple competing theories.
**Mechanism**: Agent Team (investigators disprove each other)

Rules:
- Investigators MUST look for DISconfirming evidence
- After initial investigation, have them debate via messaging
- Rate confidence: high/medium/low
- If no hypothesis fits, generate new ones

## 4. Layer Specialists
**Purpose**: Changes spanning multiple architectural layers.
**Mechanism**: Agent Team (layers need interface contracts)

Structure:
- Frontend teammate: UI changes in specific files
- Backend teammate: API and business logic in specific files
- Testing teammate: tests at all levels
- Define API contracts before implementation starts

## 5. Red Team / Blue Team
**Purpose**: Security review, adversarial testing.
**Mechanism**: Agent Team (requires back-and-forth)

Rules:
- Red team gets explicit permission to be aggressive
- Maximum 3 attack/defend rounds
- Red team rates findings by severity
- Blue team must fix all critical/high findings

## Token Cost Awareness

| Approach | Relative Cost |
|----------|--------------|
| Solo agent | 1x |
| 3 subagents | ~2-3x |
| 3-person agent team | ~5-8x |

Broadcasting to all teammates multiplies cost by team size. Prefer targeted messages.
