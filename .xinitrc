RED="\e[31m"
RESET="\e[0m"
YELLOW="\033[33m"
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile
if command -v picom > /dev/null 2>&1; then
  picom &
else
  echo -e "$YELLOW[WARN]$RESET picom not found" >&2
fi
if command -v awesome > /dev/null 2>&1; then
  exec awesome
else
  echo -e "$RED[ERROR]$RESET awesome not found" >&2
fi
