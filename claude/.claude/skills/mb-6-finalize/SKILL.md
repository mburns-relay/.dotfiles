# mb-6-finalize

Retire a shipped feature's scratch docs and promote anything durable. Run **after the
feature PR merges** — this is what keeps `docs/feature/` from turning into a graveyard of
stale build logs.

## Usage

```
/mb-6-finalize <ticket>
```

Run once `<ticket>`'s PR is merged to `main`.

## Principle

`docs/feature/sc-<id>/` is a **temporary** per-ticket workspace (the DISCUSS→DELIVER wave
artifacts). Once the work ships, code + git are the source of truth. The wave logs are
history and must not sit in the live docs tree implying they're current. See
`docs/README.md` for the lifecycle. **Status never goes in docs** — it lives in Shortcut
and git log.

## Steps

### 1. Branch

```bash
git checkout main && git pull
git checkout -b chore-finalize-sc-<id>
```

### 2. Promote durable artifacts (ask before each)

Scan `docs/feature/sc-<id>/` for content that outlives the ticket and move it to a
permanent home. Prompt the user to confirm each:

- A real architectural decision → a new ADR in `docs/decisions/` (Status/Date/Deciders header).
- A reference catalog, schema, or SQL that is the best/only captured copy → `docs/data-layer/`
  or `docs/reference/`.
- Anything else durable → the matching permanent directory.

Leave the rest (discuss/design/distill/deliver, plan.md, WORK.md, RISKS.md) as-is — they
travel to the archive in the next step, not the live tree.

### 3. Archive the workspace

```bash
mkdir -p docs/archive/feature
git mv docs/feature/sc-<id> docs/archive/feature/sc-<id>
```

Do **not** delete it — `docs/archive/` is the single historical graveyard (see `CLAUDE.md`).

### 4. Fix links

Repoint any live doc that linked into `docs/feature/sc-<id>/` at the promoted permanent
path (grep for the old path; only `docs/archive/**` may keep the old link).

### 5. Commit + PR

```bash
git add -A
git commit  # "Finalize sc-<id>: archive wave docs, promote <durable artifact>"
```

Open a small housekeeping PR (via `pr-specialist`), then `finish-task` once merged.
