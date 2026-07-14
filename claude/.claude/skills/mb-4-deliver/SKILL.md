# mb-4-deliver

TDD implementation following the 🔴→🟢→🧬→♻️ cycle.

**Heavy skill** - uses one subagent per implementation slice.

## Usage

```
/mb-4-deliver
```

Run after `/mb-3-distill` has created failing acceptance tests.

## Subagents Used

`nw-software-crafter` - one Task invocation per slice from the roadmap.

## TDD Cycle

For each slice, follow this strict cycle:

```
🔴 RED     → Write/run failing test, commit
🟢 GREEN   → Write minimum code to pass, commit
🧬 MUTATE  → Run mutation testing, fix survivors, commit
♻️ REFACTOR → Clean up code, commit
```

### Commit Message Convention

Each commit uses the appropriate emoji prefix:
- `🔴 Add failing test for <description>`
- `🟢 Make <description> test pass`
- `🧬 Kill mutation survivors in <file>`
- `♻️ Refactor <description>`

## Steps

### 1. Load Context

Read the implementation roadmap:
```
docs/feature/sc-<id>/distill.md
```

The roadmap defines slices in order:
```markdown
## Implementation Roadmap

1. [ ] First slice - makes tests 1-2 pass
2. [ ] Second slice - makes tests 3-4 pass
3. [ ] Third slice - makes remaining tests pass
```

### 2. Execute Slices (Subagent per Slice)

For each slice in the roadmap, delegate to `nw-software-crafter`:

```
Task(
  subagent_type="nw-software-crafter",
  prompt="""
    Implement slice: [slice name]

    Context:
    - Feature: SC-<id>
    - Design: [reference design.md key points]
    - Tests to make pass: [list specific tests]

    TDD Protocol (STRICT):

    1. 🔴 RED
       - Run the failing tests to confirm they fail
       - Commit: git commit -m "🔴 Add failing test for [description]"
         (if tests already exist from distill, skip this commit)

    2. 🟢 GREEN
       - Write MINIMUM code to make tests pass
       - No extra features, no premature optimization
       - Run tests to confirm green
       - Commit: git commit -m "🟢 Make [description] test pass"

    3. 🧬 MUTATE
       - For Ruby: rake test:mutate:branch
       - For JS: yarn mutation
       - Target: 100% mutation kill rate
       - If ANY mutations survive, add tests to kill them
       - Commit: git commit -m "🧬 Kill mutation survivors in [file]"
       - If already at 100%, commit: git commit -m "🧬 Verify 100% mutation coverage for [file]"

    4. ♻️ REFACTOR
       - Clean up code while keeping tests green
       - Apply SOLID principles if obvious improvements
       - Commit: git commit -m "♻️ Refactor [description]"
       - If no refactoring needed, commit: git commit -m "♻️ No refactoring needed for [description]"

    Files to modify:
    [list from design.md]

    Namespace rules:
    - Stay within app/domains/<domain>/<feature>/
    - Only use public API of other domains
    - Never reach into internal implementation of other namespaces

    Return when slice is complete with all tests passing and mutations killed.
  """
)
```

### 3. Track Progress

After each slice completes, update distill.md:

```markdown
## Implementation Roadmap

1. [x] First slice - makes tests 1-2 pass ✅
2. [ ] Second slice - makes tests 3-4 pass  ← in progress
3. [ ] Third slice - makes remaining tests pass
```

### 4. Verify All Tests Pass

After all slices complete:

```bash
bin/rails test app/domains/<domain>/<feature>/
```

All tests should pass.

### 5. Final Mutation Check

Run mutation testing on the entire feature:

```bash
rake test:mutate:branch
```

Target: 100% mutation kill rate. Do not settle for less.

### 6. Update Feature Docs

Mark delivery complete in a summary:

```markdown
# Deliver: [Feature Name]

**Story:** SC-<id>
**Date:** <today>

## Slices Completed

| Slice                | Tests | Mutations Killed |
|----------------------|-------|------------------|
| Core service         | 3     | 100%             |
| Email integration    | 2     | 100%             |
| Edge cases           | 3     | 100%             |

## Commits

- 🔴 Add failing test for order confirmation email
- 🟢 Make order confirmation email test pass
- 🧬 Kill mutation survivors in email_service.rb
- ♻️ Refactor email template selection
- ...

## Test Summary

```
X tests, X assertions, 0 failures, 0 errors
Mutation score: XX%
```
```

## Output

- Implementation complete with commits following emoji convention
- All tests passing
- Mutation score: 100%
- Updated docs/feature/sc-<id>/distill.md (roadmap checkboxes)

Confirm to user:
```
> Slices completed: 3/3
> Tests: 8 passing
> Mutation score: 100%
> Commits: 12
>
> Ready for /mb-5-pr
```

## Important Notes

### Minimum Viable Code
In the 🟢 GREEN phase, write the absolute minimum code to pass. Resist the urge to:
- Add error handling for cases not tested
- Optimize prematurely
- Add features beyond current slice

### Mutation Testing
The 🧬 MUTATE phase catches:
- Missing assertions
- Dead code
- Untested branches

**Target: 100% mutation kill rate.** If mutations survive, the test suite has gaps. Add tests to kill every survivor. Do not proceed until 100% is achieved. Hard cases are learning opportunities.

### One Slice at a Time
Each slice runs in its own subagent context. This:
- Keeps context focused
- Prevents cross-slice confusion
- Creates clean commit history

### Commit Early, Commit Often
Each phase gets its own commit. This:
- Documents the TDD process
- Makes reverting easy
- Shows reviewers the development flow

**Every slice must have all 4 commits: 🔴→🟢→🧬→♻️**

Even if mutation coverage is already 100%, commit 🧬 to verify it. Even if no refactoring is needed, commit ♻️ to confirm the code is clean. This creates a consistent, reviewable history.
