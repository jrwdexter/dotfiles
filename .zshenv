# Additional PATH information
export PATH="$HOME/Dropbox/script/bash:$PATH:$HOME/bin:$HOME/.local/bin:/usr/local/go/bin:$HOME/.cargo/bin:$HOME/.dotnet/tools:/opt/azure-cli/bin"
export EDITOR=nvim

# Add if windows sometime - maybe?
export XDG_DOWNLOAD_DIR=/mnt/c/Users/Jonathan/Downloads
export XDG_DOCUMENTS_DIR=/mnt/c/Users/Jonathan/Documents
export XDG_MUSIC_DIR=/mnt/c/Users/Jonathan/Music
export XDG_PICTURES_DIR=/mnt/c/Users/Jonathan/Dropbox/media
export XDG_VIDEOS_DIR=/mnt/c/Users/Jonathan/Videos
export XDG_SCREENSHOTS_DIR=/mnt/c/Users/Jonathan/Pictures/Screenshots
export XDG_DROPBOX_DIR=/mnt/c/Users/Jonathan/Dropbox

# Support for GPG 2
export GPG_TTY=$(tty)

# RC Files
export RIPGREP_CONFIG_PATH=~/.ripgreprc

# Set PULSE_SERVER for audio
if [ -f /etc/resolv.conf ]; then
  export PULSE_SERVER=tcp:$(grep nameserver /etc/resolv.conf | awk '{print $2}');
fi

# Set DISPLAY
if [ -f /etc/resolv.conf ]; then
  export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0 ||
  export LIBGL_ALWAYS_INDIRECT=1
else
  export DISPLAY="127.0.1.1:0"
fi

# Import any private variables as required
if [ -f ~/.zshenv-private ]; then
  source ~/.zshenv-private
fi
