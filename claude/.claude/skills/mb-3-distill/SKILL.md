# mb-3-distill

Write acceptance tests before implementation (Outside-In TDD).

## Usage

```
/mb-3-distill
```

Run after `/mb-2-design` has been APPROVED.

## Subagents Used

Optional delegation to `nw-acceptance-designer` for complex test scenarios.

## Steps

### 1. Load Context

Read the feature artifacts:
```
docs/feature/sc-<id>/discuss.md   # acceptance criteria
docs/feature/sc-<id>/design.md    # file structure, public API
```

### 2. Map Acceptance Criteria to Tests

For each acceptance criterion in discuss.md, create a test scenario:

```
Criterion: "User receives email after checkout"
    ↓
Test: Given a completed order, when checkout finishes, then email is sent
```

### 3. Write Given-When-Then Scenarios

For each test scenario, define:

```markdown
### Scenario: [Name]

**Given** [initial state/context]
**When** [action/trigger]
**Then** [expected outcome]

**Edge cases:**
- [variation 1]
- [variation 2]
```

### 4. Create Test Files

Following the colocated test convention, create test files alongside implementation files:

```
app/domains/<domain>/<feature>/
  service.rb
  service_test.rb      # ← tests go here
```

Write actual test code:

```ruby
# frozen_string_literal: true

require "test_helper"

class Domains::<Domain>::<Feature>::ServiceTest < ActiveSupport::TestCase
  # Given-When-Then maps to Arrange-Act-Assert

  test "description from scenario" do
    # Given (Arrange)
    setup_initial_state

    # When (Act)
    result = Service.call(params)

    # Then (Assert)
    assert expected_outcome
  end
end
```

### 5. Tests Should FAIL

At this stage, tests must fail because implementation doesn't exist yet.

Run tests to confirm they fail:
```bash
bin/rails test <test_file>
```

Expected output: failures (not errors from missing files).

If tests pass, something is wrong - we haven't implemented anything yet.

### 6. Create Implementation Stubs

Create minimal stubs so tests fail with assertion errors (not NoMethodError):

```ruby
# app/domains/<domain>/<feature>/service.rb
module Domains
  module <Domain>
    module <Feature>
      class Service
        def self.call(...)
          raise NotImplementedError
        end
      end
    end
  end
end
```

### 7. Write distill.md

Create the output file:

```markdown
# Distill: [Feature Name]

**Story:** SC-<id>
**Date:** <today>

## Test Scenarios

### Scenario 1: [Name]
**Given** ...
**When** ...
**Then** ...

### Scenario 2: [Name]
...

## Test Files Created

| File                                          | Scenarios |
|-----------------------------------------------|-----------|
| app/domains/.../service_test.rb               | 3         |
| app/domains/.../other_test.rb                 | 2         |

## Test Status

All tests currently FAILING (as expected before implementation).

```bash
bin/rails test app/domains/<domain>/<feature>/
# X tests, X assertions, X failures, 0 errors
```

## Implementation Roadmap

Order of implementation for TDD:

1. [ ] [First slice] - makes tests 1-2 pass
2. [ ] [Second slice] - makes tests 3-4 pass
3. [ ] [Third slice] - makes remaining tests pass
```

## Output

- `docs/feature/sc-<id>/distill.md`
- Test files in `app/domains/<domain>/<feature>/*_test.rb`

Confirm to user:
- Number of test scenarios
- Test files created
- Implementation roadmap

```
> Scenarios: 5
> Test files: 2
> Tests: 8 (all failing as expected)
>
> Roadmap:
> 1. Core service (3 tests)
> 2. Email integration (2 tests)
> 3. Edge cases (3 tests)
>
> Ready for /mb-4-deliver
```

## When to Delegate

For complex features with many test scenarios, delegate to `nw-acceptance-designer`:

```
Task(
  subagent_type="nw-acceptance-designer",
  prompt="""
    Design acceptance tests for: [feature summary]

    Requirements (from discuss.md):
    [paste acceptance criteria]

    Architecture (from design.md):
    [paste file structure and public API]

    Create:
    1. Given-When-Then scenarios for each criterion
    2. Edge case scenarios
    3. Test file structure following colocated convention

    Tests should fail initially - we haven't implemented yet.
  """
)
```

Use delegation when:
- More than 5 acceptance criteria
- Complex edge cases
- Multiple integration points
