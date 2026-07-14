# mb-5-pr

Code review, CI verification, and PR creation.

**Heavy skill** - uses subagents for isolated context.

## Usage

```
/mb-5-pr
```

Run from the feature branch after `/mb-4-deliver` is complete.

## Subagents Used

1. `code-architecture-reviewer` - final code quality check
2. `pr-specialist` - generate PR description

## Steps

### 1. Pre-flight Checks

Verify prerequisites:
```bash
git status  # ensure clean working tree
git log origin/main..HEAD --oneline  # show commits to be included
```

Read feature artifacts:
- `docs/feature/sc-<id>/discuss.md`
- `docs/feature/sc-<id>/design.md`
- `docs/feature/sc-<id>/distill.md`

### 2. Code Review (Subagent)

Delegate to `code-architecture-reviewer`:

```
Task(
  subagent_type="code-architecture-reviewer",
  prompt="""
    Review the changes on this branch for PR readiness.

    Reference documents:
    - docs/development-guides/code-review-guidelines.md
    - docs/development-guides/qa-review-checklist.md

    Check for:
    1. Namespace conventions (never reach inside other namespaces)
    2. Test coverage (colocated tests)
    3. No commented-out code
    4. No TODO/FIXME without ticket references
    5. Follows app/domains/ structure

    Return:
    - APPROVED: ready for PR
    - BLOCKED: list of issues that must be fixed

    Be strict. Better to catch issues now than in human review.
  """
)
```

**If BLOCKED:** Stop and report issues. User must fix before re-running `/mb-5-pr`.

### 3. CI Verification

Run the full CI suite:
```bash
bin/ci
```

**If CI fails:** Stop and report failures. Must pass before PR creation.

### 4. PR Creation (Subagent)

Delegate to `pr-specialist`:

```
Task(
  subagent_type="pr-specialist",
  prompt="""
    Create a pull request for this feature branch.

    Context:
    - Feature docs in docs/feature/sc-<id>/
    - Shortcut story: <story-url>

    Requirements:
    1. PR title: concise, imperative mood
    2. PR body must include:
       - ## Summary (3-5 bullet points)
       - ## Test plan (what to verify)
       - ## Shortcut link
    3. Use gh pr create with HEREDOC for body

    Link format for Shortcut: https://app.shortcut.com/peel/story/<id>
  """
)
```

### 5. Update Shortcut (Optional)

Keep ticket in "In Development" - PR is open, not merged yet.

Optionally add PR link to story:
```
mcp__shortcut__stories-add-external-link(
  storyPublicId=<id>,
  externalLink=<pr-url>
)
```

## Output

Report to user:
- Code review status (APPROVED)
- CI status (PASSED)
- PR URL

```
> Code review: APPROVED
> CI: PASSED
> PR: https://github.com/org/repo/pull/123
>
> Ready for human review. Ticket remains In Development until merged.
```

## After merge

Once this PR merges, run `/mb-6-finalize <id>` to promote any durable artifacts and archive
the `docs/feature/sc-<id>/` workspace. This keeps the live docs tree honest — feature dirs
are scratch, not permanent. See `docs/README.md` for the doc lifecycle.

## Blocking Conditions

This skill will STOP and require fixes if:
1. Code review returns BLOCKED
2. CI fails
3. Git working tree is dirty

Do not proceed to PR creation if any check fails.
