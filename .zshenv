# Additional PATH information
export PATH="$HOME/Dropbox/script/bash:$PATH:$HOME/bin:$HOME/.local/bin:/usr/local/go/bin:$HOME/.cargo/bin:$HOME/.dotnet/tools"
export EDITOR=nvim

# Add if windows sometime - maybe?
export XDG_DOWNLOAD_DIR=/mnt/c/Users/Jonathan/Downloads
export XDG_DOCUMENTS_DIR=/mnt/c/Users/Jonathan/Documents
export XDG_MUSIC_DIR=/mnt/c/Users/Jonathan/Music
export XDG_PICTURES_DIR=/mnt/c/Users/Jonathan/Dropbox/media
export XDG_VIDEOS_DIR=/mnt/c/Users/Jonathan/Videos
export XDG_SCREENSHOTS_DIR=/mnt/c/Users/Jonathan/Pictures/Screenshots
export XDG_DROPBOX_DIR=/mnt/c/Users/Jonathan/Dropbox

# Set PULSE_SERVER for audio
if [ -f /etc/resolv.conf ]; then
  export PULSE_SERVER=tcp:$(grep nameserver /etc/resolv.conf | awk '{print $2}');
fi

# Set DISPLAY
[ -f /etc/resolv.conf ] &&
  export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0 ||
  export DISPLAY="127.0.1.1:0"

# Import any private variables as required
if [ -f ~/.zshenv-private ]; then
  source ~/.zshenv-private
fi
