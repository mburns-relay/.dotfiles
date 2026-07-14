# mb-1-discuss

JTBD analysis, requirements gathering, and acceptance criteria definition.

## Usage

```
/mb-1-discuss
```

Run after `/mb-0-workon` has set up the ticket and branch.

## Subagents Used

Optional delegation to `nw-product-owner` for complex features requiring deep requirements analysis.

## Steps

### 1. Load Context

Read the Shortcut story details:
```
mcp__shortcut__stories-get-by-id(storyPublicId=<id>, full=true)
```

Also check for any existing discuss.md:
```
docs/feature/sc-<id>/discuss.md
```

### 2. Analyze Requirements

From the ticket description and any comments, identify:
- What problem is being solved?
- Who experiences this problem?
- What does success look like?

### 3. Clarify with User (AskUserQuestion)

Ask clarifying questions to fill gaps. Common questions:

- "What triggers this feature? (user action, scheduled, event)"
- "Who are the primary users?"
- "Are there edge cases we should handle explicitly?"
- "What's out of scope for this ticket?"

Use `AskUserQuestion` with concrete options where possible.

### 4. Produce JTBD Statement

Write a one-liner in Jobs-to-be-Done format:

```
When [situation], I want to [motivation], so I can [expected outcome].
```

### 5. Write User Stories

For each distinct user flow, write:

```markdown
### US-1: [Short name]

**As a** [user type]
**I want to** [action]
**So that** [benefit]

#### Acceptance Criteria
- [ ] Given [context], when [action], then [result]
- [ ] Given [context], when [action], then [result]
```

### 6. Define Scope

Explicitly list:
- **In scope:** What this ticket will deliver
- **Out of scope:** What this ticket will NOT deliver (important for avoiding scope creep)
- **Assumptions:** Things we're taking as given
- **Open questions:** Things still to be determined

### 7. Definition of Done

List what "done" means for this feature:
- All acceptance criteria pass
- Tests written and passing
- Code review approved
- CI green
- (any feature-specific items)

### 8. Write discuss.md

Create the output file:

```markdown
# Discuss: [Feature Name]

**Story:** SC-<id>
**Date:** <today>

## JTBD

When [situation], I want to [motivation], so I can [expected outcome].

## User Stories

### US-1: [Name]
...

## Scope

### In Scope
- ...

### Out of Scope
- ...

### Assumptions
- ...

### Open Questions
- ...

## Definition of Done
- [ ] ...
```

## Output

```
docs/feature/sc-<id>/discuss.md
```

Confirm to user:
- JTBD statement
- Number of user stories
- Any remaining open questions

```
> JTBD: When a user completes checkout, I want to send a confirmation email, so they have a record of their purchase.
>
> User Stories: 3
> Open Questions: 1 (email template design TBD)
>
> Ready for /mb-2-design
```

## When to Delegate

For complex features with many user types or unclear requirements, delegate to `nw-product-owner`:

```
Task(
  subagent_type="nw-product-owner",
  prompt="""
    Conduct requirements gathering for: [feature description]

    Shortcut ticket: SC-<id>
    Description: [ticket description]

    Produce:
    1. JTBD statement
    2. User stories with acceptance criteria
    3. Scope definition
    4. Definition of Done

    Ask clarifying questions if needed.
  """
)
```

Use delegation when:
- Multiple user personas involved
- Complex business logic
- Unclear or conflicting requirements
- Large feature scope
