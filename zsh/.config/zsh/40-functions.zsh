# cheat.sh — tldr for commands
cheat() { curl -s "cheat.sh/$1"; }

# Safer force-push (carried over): refuse on protected branches.
gpf() {
  local branch; branch=$(git rev-parse --abbrev-ref HEAD)
  if [[ "$branch" == "main" || "$branch" == "master" || "$branch" == "develop" ]]; then
    echo "Refusing to force push to $branch"; return 1
  fi
  git push --force-with-lease "$@"
}

# dev — start the Rails app on the worktree's web port (3000 + N).
# Robust version: derives N from the git worktree ROOT, so it works from any
# subdirectory (the old version used `basename $PWD`). DB isolation is handled
# app-side via Rails.root basename, so we only need to set PORT.
dev() {
  local root dir offset port branch label
  root=$(git rev-parse --show-toplevel 2>/dev/null) || root="$PWD"
  dir=$(basename "$root")
  offset=0
  [[ "$dir" == p[0-9]* ]] && offset="${dir#p}"
  port=$((3000 + offset))
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  label="${branch:-$dir}"
  [[ -n "$TMUX" ]] && tmux rename-window "$label"
  echo "Starting on port $port ($label)"
  PORT=$port bin/dev "$@"
}
