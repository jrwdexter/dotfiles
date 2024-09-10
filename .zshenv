# Additional PATH information
export PATH="$HOME/Dropbox/script/bash:$PATH:$HOME/bin:$HOME/.local/bin:/usr/local/go/bin:$HOME/.cargo/bin:$HOME/.dotnet/tools:/opt/azure-cli/bin"
export EDITOR=nvim

# Add if windows sometime - maybe?
export XDG_DOWNLOAD_DIR=~/Downloads/
export XDG_DOCUMENTS_DIR=~/Documents/
export XDG_MUSIC_DIR=~/Music/
export XDG_PICTURES_DIR=~/Pictures/
export XDG_VIDEOS_DIR=~/Videos/
export XDG_SCREENSHOTS_DIR=~/Pictures/Screenshots/
export XDG_DROPBOX_DIR=~/Dropbox/

# Support for GPG 2
export GPG_TTY=$(tty)

# RC Files
export RIPGREP_CONFIG_PATH=~/.ripgreprc

# Import any private variables as required
if [ -f ~/.zshenv-private ]; then
  source ~/.zshenv-private
fi
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

#if [ $RANGER_LEVEL ]; then
  #if [ -d $HOME/.oh-my-zsh/plugins/z ]; then
    export ZSHZ_SRC=$HOME/.oh-my-zsh/plugins/z/z.plugin.zsh
    #export _Z_SRC=$HOME/.oh-my-zsh/plugins/z/z.plugin.zsh
  #fi
#fi

# Begin added by argcomplete
fpath=( /usr/lib/python3.12/site-packages/argcomplete/bash_completion.d "${fpath[@]}" )
# End added by argcomplete
