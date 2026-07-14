# mb-2-design

Debate approaches, define architecture, and validate design before implementation.

**Heavy skill** - uses subagents to isolate context-heavy work.

## Usage

```
/mb-2-design
```

Run after `/mb-1-discuss` has produced requirements.

## Subagents Used

1. `debate-moderator` - evaluate multiple approaches
2. `code-architecture-reviewer` - validate design before proceeding

## Steps

### 1. Load Context

Read the discuss output:
```
docs/feature/sc-<id>/discuss.md
```

Understand:
- JTBD statement
- User stories and acceptance criteria
- Scope constraints

### 2. Explore Existing Code

Search for related patterns in the codebase:
- Similar features in `app/domains/`
- Relevant services, models, or events
- Existing tests that might inform approach

### 3. Debate Phase (Subagent)

Delegate to `debate-moderator` to evaluate approaches:

```
Task(
  subagent_type="debate-moderator",
  prompt="""
    Evaluate implementation approaches for: [feature summary]

    Requirements:
    [paste JTBD and key acceptance criteria]

    Codebase context:
    - Uses app/domains/ structure with strict namespace boundaries
    - Never reach inside another namespace's internals
    - Prefer composition over inheritance
    - Events for cross-domain communication

    Present 2-3 approaches:
    1. [Approach A] - brief description
    2. [Approach B] - brief description
    3. [Approach C if relevant]

    For each, evaluate:
    - Alignment with existing patterns
    - Complexity (prefer simple)
    - Testability
    - Future maintainability

    Return:
    - RECOMMENDED: [approach] with rationale
    - TRADE-OFFS: what we're accepting
  """
)
```

### 4. Architecture Definition

Based on the recommended approach, define:

#### File Structure
```
app/domains/<domain>/
  <feature>/
    <files>.rb
    <files>_test.rb  # colocated tests
```

#### Namespace Rules
- Public API surface (what other domains can call)
- Internal implementation (hidden from other domains)
- Events emitted (if any)

#### Dependencies
- What existing code this feature depends on
- What might depend on this feature

### 5. Review Gate (Subagent)

Delegate to `code-architecture-reviewer` for validation:

```
Task(
  subagent_type="code-architecture-reviewer",
  prompt="""
    Review this design for: [feature summary]

    Proposed approach:
    [paste recommended approach]

    File structure:
    [paste proposed files]

    Check against:
    - docs/README.md — the authoritative-doc index; link to existing reference/ADRs rather than re-explaining architecture in the design doc
    - docs/development-guides/code-review-guidelines.md
    - Namespace conventions (strict boundaries)
    - Existing patterns in app/domains/

    Return:
    - APPROVED: design is sound, proceed to implementation
    - BLOCKED: [specific issues] - must resolve before proceeding

    Be strict. A flawed design is expensive to fix later.
  """
)
```

**If BLOCKED:** Report issues. User must address concerns before proceeding.

### 6. Write design.md

Create the output file:

```markdown
# Design: [Feature Name]

**Story:** SC-<id>
**Date:** <today>
**Status:** [APPROVED/BLOCKED]

## Approach

### Decision
[Recommended approach]

### Rationale
[Why this approach was chosen]

### Trade-offs Accepted
- [trade-off 1]
- [trade-off 2]

### Alternatives Considered
1. [Approach B] - rejected because [reason]
2. [Approach C] - rejected because [reason]

## Architecture

### File Structure
```
app/domains/<domain>/
  ...
```

### Public API
- `ClassName.method_name` - description

### Internal Implementation
- [hidden classes/modules]

### Events
- `EventName` - when [trigger], payload: [fields]

### Dependencies
- Depends on: [list]
- Depended on by: [list or "none yet"]

## Review Status

**Reviewer:** code-architecture-reviewer
**Result:** [APPROVED/BLOCKED]
**Notes:** [any reviewer comments]
```

## Output

```
docs/feature/sc-<id>/design.md
```

Confirm to user:
- Recommended approach
- File structure
- Review status

```
> Approach: Service object with event emission
> Files: 4 new files in app/domains/notifications/
> Review: APPROVED
>
> Ready for /mb-3-distill
```

## Blocking Conditions

This skill will STOP if:
1. `code-architecture-reviewer` returns BLOCKED

Do not proceed to `/mb-3-distill` until design is APPROVED.
