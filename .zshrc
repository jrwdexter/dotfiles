#####################################
############# OH-MY-ZSH #############
#####################################

export ZSH=$HOME/.oh-my-zsh

# POWERLEVEL9K_MODE='awesome-patched'
ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(virtualenv status root_indicator background_jobs time)

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
  osx
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

if [[ -z ${SSH_AUTH_SOCK+x} ]]
then
  eval $(ssh-agent -s)
  ssh-add
fi

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

alias tf=terraform
alias g=git

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
  gcalcli --calendar jdexter@nerdery.com agenda $today $tomorrow --nodeclined
}

tomorrow() {
  tomorrow=$(date -d "+1 days" +"%Y-%m-%d")
  nextDay=$(date -d "+2 days" +"%Y-%m-%d")
  gcalcli --calendar jdexter@nerdery.com agenda $tomorrow $nextDay --nodeclined
}

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

alias x="(nohup mopidy > /tmp/mopidy.out &) && (nohup awesome > /tmp/awesome.out &) && (nohup picom --experimental-backends > /tmp/picom.out &)"
