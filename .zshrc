
# SSH Agent
if [[ -z ${SSH_AUTH_SOCK+x} ]]
then
  eval $(ssh-agent -s)
  ssh-add
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#####################################
############# OH-MY-ZSH #############
#####################################

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

if [ -f /usr/share/nvm/init-nvm.sh ]; then
  source /usr/share/nvm/init-nvm.sh
fi

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  macos
  gcloud
  virtualenv
  fzf
  git
  github
  nvm
  thefuck
  z
)

source $ZSH/oh-my-zsh.sh

# Manually use kitty
if type kitty > /dev/null; then
  kitty + complete setup zsh | source /dev/stdin
fi

#####################################
######### NON-ZSH SETTINGS ##########
#####################################

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

#####################################
####### SERVICES + LIBRARIES ########
#####################################

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jdexter/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jdexter/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jdexter/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jdexter/google-cloud-sdk/completion.zsh.inc'; fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/usr/local/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup # <<< conda initialize <<<

#####################################
#### ALIASES + CUSTOM FUNCTIONS #####
#####################################

if type terraform > /dev/null ; then
  alias tf=terraform
fi

if type docker > /dev/null ; then
  alias dk=docker
  alias dks='docker stop'
  #dksa() {
    #docker ps --format "{{.ID}}" | xargs docker stop
  #}

  alias dksa='docker ps --format "{{.ID}}" | xargs docker stop'
  alias dkps='docker ps'
  alias dkl='docker logs'
  alias dklf='docker logs -f'
  alias dki='docker images'
  alias dkrm='docker rm'
fi

alias g=git

if (command -v cmdg > /dev/null); then
  alias cmdgp="cmdg -config ~/.cmdg/cmdg-personal.conf"
fi

opp() {
  >&1 echo -ne "Querying for account...\r"
  matches=`op item list | grep $1`
  if [[ $? != 0 ]]; then
    >&1 echo -ne "No matches found\n"
    return
  fi
  if [[ `printf %s "$matches" | wc -l` > 1 ]]; then
    id=`printf %s "$matches" | fzf | sed -E 's/\s.*//'`
    op item get $id --fields=password | head | xclip -selection clipboard -r
    >&1 echo -ne "Password copied to clipboard.\n"
  else
    id=`printf %s "$matches" | sed -E 's/\s.*//'`
    op item get $id --fields=password | head | xclip -selection clipboard -r
    >&1 echo -ne "Password copied to clipboard.\n"
  fi

}

lpw() {
  >&1 echo -ne "Querying for account...\r"
  matches=`lpass show -xjG $1`
  if [[ $? != 0 ]]; then
    return
  fi
  if [[ `printf %s "$matches" | jq '. | length'` > 1 ]]; then
    
    id=`printf %s "$matches" | jq -r '.[] | "\u001B[1;34m" + .fullname + " \u001B[1;32m[id: " + .id + "]" + " \u001B[2;37m{" + .username + "}\u001B[0m"' | fzf --ansi | sed -E "s/^.*id: ([0-9]+).*$/\1/"`
    lpass show -pc $id
    >&1 echo -ne "Password copied to clipboard.\n"
  else
    lpass show -pcG $1
    >&1 echo -ne "Password copied to clipboard.\n"
  fi
}

today() {
  today=$(date +"%Y-%m-%d")
  tomorrow=$(date -d "+1 days" +"%Y-%m-%d")
  gcalcli agenda $today $tomorrow --nodeclined
}

tomorrow() {
  tomorrow=$(date -d "+1 days" +"%Y-%m-%d")
  nextDay=$(date -d "+2 days" +"%Y-%m-%d")
  gcalcli agenda $tomorrow $nextDay --nodeclined
}

next() {
  now=$(date +"%H:%M")
  gcalcli agenda "$now" "23:59" --nodeclined | head -n 2
}

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

alias ccb='clear && colorblocks'

#####################################
########## STARTUP ROUTINE ##########
#####################################

if command -v toilet &> /dev/null; then
  r=$(($RANDOM % 100))
  if [ $r -lt 2 ]; then
    echo ""
    toilet -f banner3-D --gay "  You've  got this" -F border
    echo ""
  elif [ $r -lt 5 ]; then
    echo ""
    toilet -f banner3-D --metal "  You've  got this"
    echo ""
  elif [ $r -lt 10 ]; then
    echo ""
    toilet -f banner3-D "  You've  got this"
    echo ""
  elif [ $r -lt 20 ]; then
    echo ""
    colorblocks
    echo ""
  elif command -v fortune &> /dev/null; then
    echo ""
    fortune
    echo ""
  fi
elif command -v cowsay &> /dev/null; then
  r=$(($RANDOM % 100))
  if [ $r -lt 15 ]; then
    cowsay "You've got this"
  elif command -v fortune &> /dev/null; then
    echo ""
    fortune
    echo ""
  fi
fi

check_or_run() {
  proc="$1"
  proc_id=$(pidof -w $proc)
  if [[ $proc_id ]]; then
    echo -e "\e[0;94m$proc\e[0m already running"
  else
    nohup $proc $2 > "/tmp/$proc.out" &
    echo -e "Starting \e[0;92m$proc\e[0m..."
  fi
}

# WSL Support

x11() {
  check_or_run "mopidy"
  check_or_run "picom" "--experimental-backends"
  check_or_run "awesome"
}

check_and_kill() {
  proc="$1"
  proc_id=$(pidof -w $proc)
  if [[ $proc_id ]]; then
    pkill -9 $proc
    echo -e "Killing \e[0;91m$proc\e[0m..."
  else
    echo -e "$proc not found"
  fi
}

kill_x11()
{
  check_and_kill "mopidy"
  check_and_kill "picom"
  check_and_kill "awesome"
}

clean_wsl_mem() {
  if [ -f /proc/sys/vm/drop_caches ]; then
    echo -e "Dropping cache..."
    if (sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'); then
      echo -e "\e[092mSuccess\e[0m: dropped cache"
    else
      echo -e "\e[093mFailure\e[0m: could not drop cache"
    fi
    
    echo -e "Compacting memory..."
    if (sudo sh -c 'echo 1 > /proc/sys/vm/compact_memory'); then
      echo -e "\e[092mSuccess\e[0m: compacted memory"
    else
      echo -e "\e[093mFailure\e[0m: could not compact memory"
    fi
  else
    echo -e "\e[093mAborting\e[0m: Not running in WSL."
  fi
}

alias vaccines='cat /tmp/awesome.out | tail -n 100 | grep "appointments" | tail -n 1 | sed -E "s/ \(string\)$//" | jq 2> /dev/null'

alias luamake=/home/mandest/src/lua-language-server/3rd/luamake/luamake

# Kubernetes aliases
source ~/.kubectl_aliases

# Azure completion
if [[ -f /opt/azure-cli/az.completion ]]; then
  source /opt/azure-cli/az.completion
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
