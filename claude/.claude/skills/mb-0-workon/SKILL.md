# mb-0-workon

Load a Shortcut ticket, create/switch branch, and move to In Development.

## Usage

```
/mb-0-workon <ticket>
```

Where `<ticket>` is either:
- Full URL: `https://app.shortcut.com/peel/story/12345/story-name`
- Story ID: `12345`

## Steps

### 1. Parse Ticket ID

Extract the numeric story ID from the input:
- If URL, extract ID from path segment after `/story/`
- If numeric, use directly

### 2. Fetch Story Details

Use `mcp__shortcut__stories-get-by-id` with the parsed story ID.

Display to user:
- Story name
- Current state
- Description summary

### 3. Move to In Development

Use `mcp__shortcut__stories-update` with:
- `storyPublicId`: the story ID
- `workflow_state_id`: 500017837 (In Development)

### 4. Get Worktree Number

Run `get-worktree-num` to determine which worktree slot (1-5) is available.

### 5. Add Claude Label

Add the appropriate `claude-N` label based on worktree number.

Label IDs:
| Worktree | Label ID |
|----------|----------|
| 1        | 65648    |
| 2        | 65649    |
| 3        | 65650    |
| 4        | 65651    |
| 5        | 65652    |

Use `mcp__shortcut__stories-update` with:
```json
{
  "storyPublicId": <id>,
  "labels": [{"name": "claude-<N>"}]
}
```

### 6. Set Up Branch

Generate a branch name from the story:
- Use `mcp__shortcut__stories-get-branch-name` to get a valid branch name

Then run:
```bash
workon <story-id> "<three-word-description>"
```

The three-word description should be derived from the story name (kebab-case, 2-4 words).

### 7. Create Feature Directory

```bash
mkdir -p docs/feature/sc-<story-id>
```

## Output

Confirm to user:
- Branch name created/switched
- Ticket moved to In Development
- Claude label applied
- Ready for `/mb-1-discuss`

## Example

```
/mb-0-workon https://app.shortcut.com/peel/story/12345/add-user-notifications

> Story: Add user notifications
> State: In Development
> Branch: sc-12345/add-user-notifications
> Label: claude-2
> Feature dir: docs/feature/sc-12345/
>
> Ready for /mb-1-discuss
```
