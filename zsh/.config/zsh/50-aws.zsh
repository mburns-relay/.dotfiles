# AWS profile switching via granted's `assume` (req 17).
# `assume` must be sourced to export AWS_PROFILE into the current shell; the
# Homebrew install provides a shell function, but alias the fzf-picker form too.
if command -v assume >/dev/null; then
  alias awsp='assume'                 # `awsp` -> fzf-pick a profile
fi

# Show the active profile quickly.
alias awswho='echo "AWS_PROFILE=${AWS_PROFILE:-<none>}"'
