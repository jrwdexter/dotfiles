# ╔═══════════════════════════════════════════════╗
# ║  Powerlevel10k instant prompt (must be first) ║
# ╚═══════════════════════════════════════════════╝
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ╔═══════════════════════════════════════════════╗
# ║  Oh My Zsh                                    ║
# ╚═══════════════════════════════════════════════╝
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  fzf
  gcloud
  git
  github
  nvm
  poetry
  poetry-env
  virtualenv
  z
)

source $ZSH/oh-my-zsh.sh

# ╔═══════════════════════════════════════════════╗
# ║  Tool integrations                            ║
# ╚═══════════════════════════════════════════════╝

# NVM
if [ -f "$HOME/.nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
if [ -f /usr/share/nvm/init-nvm.sh ]; then
  source /usr/share/nvm/init-nvm.sh
fi

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Kitty shell completions
if type kitty &> /dev/null; then
  kitty + complete setup zsh | source /dev/stdin
fi

# Direnv
if type direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# pay-respects (typo correction)
if command -v pay-respects &> /dev/null; then
  eval "$(pay-respects zsh --alias fuck)"
fi

# Kubernetes
[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases

# Azure CLI
if [[ -f /opt/azure-cli/bin/az.completion.sh ]]; then
  source /opt/azure-cli/bin/az.completion.sh
fi

# Nuke build system
if type nuke &> /dev/null; then
  _nuke_zsh_complete() {
    local completions=("$(nuke :complete "$words")")
    reply=( "${(ps:\n:)completions}" )
  }
  compctl -K _nuke_zsh_complete nuke
fi

# ╔═══════════════════════════════════════════════╗
# ║  Aliases                                      ║
# ╚═══════════════════════════════════════════════╝

alias g=git
alias lg=lazygit
alias nf='clear && echo "" && neofetch'
alias ccb='clear && colorblocks'

if type terraform &> /dev/null; then
  alias tf=terraform
fi

if type docker &> /dev/null; then
  alias dk=docker
  alias dks='docker stop'
  alias dksa='docker ps --format "{{.ID}}" | xargs docker stop'
  alias dkps='docker ps'
  alias dkl='docker logs'
  alias dklf='docker logs -f'
  alias dki='docker images'
  alias dkrm='docker rm'
fi

# ╔═══════════════════════════════════════════════╗
# ║  Functions                                    ║
# ╚═══════════════════════════════════════════════╝

# ── 1Password (search + copy password to clipboard) ──
opp() {
  echo -ne "Querying for account...\r"
  local matches
  matches=$(op item list | grep "$1")
  if [[ $? != 0 ]]; then
    echo "No matches found"
    return 1
  fi

  local id
  if [[ $(printf '%s' "$matches" | wc -l) -gt 1 ]]; then
    id=$(printf '%s' "$matches" | fzf | sed -E 's/\s.*//')
  else
    id=$(printf '%s' "$matches" | sed -E 's/\s.*//')
  fi

  op item get "$id" --fields=password | head | xclip -selection clipboard -r
  echo "Password copied to clipboard."
}

# ── LastPass (search + copy password to clipboard) ──
lpw() {
  echo -ne "Querying for account...\r"
  local matches
  matches=$(lpass show -xjG "$1")
  if [[ $? != 0 ]]; then
    return 1
  fi

  if [[ $(printf '%s' "$matches" | jq '. | length') -gt 1 ]]; then
    local id
    id=$(printf '%s' "$matches" \
      | jq -r '.[] | "\u001B[1;34m" + .fullname + " \u001B[1;32m[id: " + .id + "]" + " \u001B[2;37m{" + .username + "}\u001B[0m"' \
      | fzf --ansi \
      | sed -E "s/^.*id: ([0-9]+).*$/\1/")
    lpass show -pc "$id"
  else
    lpass show -pcG "$1"
  fi
  echo "Password copied to clipboard."
}

# ── Calendar (requires gcalcli) ──
today() {
  local today=$(date +"%Y-%m-%d")
  local tomorrow=$(date -d "+1 days" +"%Y-%m-%d")
  gcalcli agenda "$today" "$tomorrow" --nodeclined
}

tomorrow() {
  local tomorrow=$(date -d "+1 days" +"%Y-%m-%d")
  local next_day=$(date -d "+2 days" +"%Y-%m-%d")
  gcalcli agenda "$tomorrow" "$next_day" --nodeclined
}

next() {
  local now=$(date +"%H:%M")
  gcalcli agenda "$now" "23:59" --nodeclined | head -n 2
}

# ── Terminal color test ──
colorblocks() {
  command='
f=3 b=4
for j in f b; do
  for i in {0..7}; do
    printf -v $j$i %b "\e[${!j}${i}m"
  done
done
d=$'"'"'\e[1m'"'"'
t=$'"'"'\e[0m'"'"'
v=$'"'"'\e[7m'"'"'

cat << EOF

 $f1██████$d██$t $f2██████$d██$t $f3██████$d██$t $f4██████$d██$t $f5██████$d██$t $f6██████$d██$t
 $f1██████$d██$t $f2██████$d██$t $f3██████$d██$t $f4██████$d██$t $f5██████$d██$t $f6██████$d██$t
 $f1██████$d██$t $f2██████$d██$t $f3██████$d██$t $f4██████$d██$t $f5██████$d██$t $f6██████$d██$t
 $ft██████$d$f7██$t $ft██████$d$f7██$t $ft██████$d$f7██$t $ft██████$d$f7██$t $ft██████$d$f7██$t $ft██████$d$f7██$t

EOF'
  /bin/sh -c $command
}

# ╔═══════════════════════════════════════════════╗
# ║  Startup MOTD                                 ║
# ╚═══════════════════════════════════════════════╝
if command -v toilet &> /dev/null; then
  r=$(($RANDOM % 100))
  if [ $r -lt 2 ]; then
    echo ""; toilet -f banner3-D --gay "  You've  got this" -F border; echo ""
  elif [ $r -lt 5 ]; then
    echo ""; toilet -f banner3-D --metal "  You've  got this"; echo ""
  elif [ $r -lt 10 ]; then
    echo ""; toilet -f banner3-D "  You've  got this"; echo ""
  elif [ $r -lt 20 ]; then
    echo ""; colorblocks; echo ""
  elif command -v fortune &> /dev/null; then
    echo ""; fortune; echo ""
  fi
elif command -v cowsay &> /dev/null; then
  r=$(($RANDOM % 100))
  if [ $r -lt 15 ]; then
    cowsay "You've got this"
  elif command -v fortune &> /dev/null; then
    echo ""; fortune; echo ""
  fi
fi

# ╔═══════════════════════════════════════════════╗
# ║  NixOS Aliases                                ║
# ╚═══════════════════════════════════════════════╝
alias nrs="sudo nixos-rebuild switch --flake .#mjl-0001"
alias nfu="nix flake update"
alias nfua="nix flake update && sudo nixos-rebuild switch --flake .#mjl-0001"

# ╔═══════════════════════════════════════════════╗
# ║  Powerlevel10k config (must be last)          ║
# ╚═══════════════════════════════════════════════╝
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
