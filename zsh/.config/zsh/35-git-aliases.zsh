# YADR-style git aliases. The short `git <x>` subcommands they delegate to
# (l, ci, cp, b, nb, t, uncommit, …) are defined in ~/.config/git/config.

# --- status / show ---
alias gs='git status'
alias gsh='git show'
alias gshow='git show'

# --- stash ---
alias gst='git stash'
alias gstsh='git stash'
alias gsp='git stash pop'
alias gsa='git stash apply'

# --- add ---
alias ga='git add -A'
alias gap='git add -p'
alias gi='${EDITOR:-nvim} .gitignore'

# --- commit ---
alias gci='git ci'
alias gcm='git ci -m'
alias gcim='git ci -m'
alias gam='git amend --reset-author'
alias guns='git unstage'
alias gunc='git uncommit'

# --- checkout / branch ---
alias gco='git co'
alias gb='git b'
alias gnb='git nb'          # new branch (checkout -b)
alias gcp='git cp'          # cherry-pick -x

# --- log ---
alias gl='git l'
alias glg='git l'
alias glog='git l'

# --- diff ---
alias gd='git diff'
alias gdc='git diff --cached -w'
alias gds='git diff --staged -w'

# --- fetch ---
alias gf='git fetch'
alias gfp='git fetch --prune'
alias gfa='git fetch --all'

# --- pull / push ---
alias gpl='git pull'
alias gplr='git pull --rebase'
alias gps='git push'
alias gpsh='git push -u origin $(git rev-parse --abbrev-ref HEAD)'

# --- merge / rebase ---
alias gm='git merge'
alias gms='git merge --squash'
alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias gbi='git rebase --interactive'

# --- remote ---
alias grv='git remote -v'
alias grr='git remote rm'
alias grad='git remote add'

# --- reset / clean ---
alias grs='git reset'
alias grsh='git reset --hard'
alias gcln='git clean'
alias gclndf='git clean -df'
alias gclndfx='git clean -dfx'

# --- submodule ---
alias gsm='git submodule'
alias gsmi='git submodule init'
alias gsmu='git submodule update'

# --- tag / bisect ---
alias gt='git t'
alias gbg='git bisect good'
alias gbb='git bisect bad'
