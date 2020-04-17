# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"

fi

if [[ $SHLVL = 1 ]]; then
  # load secure environment variables
  source "$HOME/.zshenv.secure"

  # Golang-related environment variables
  export GOPATH="$HOME/go"
  export GOPROXY="direct"
  export GOSUMDB="off"

  # local bin and GOBIN path
  export PATH="$HOME/bin:$PATH"
  export PATH="$GOPATH/bin:$PATH"

  # other paths
  export PATH="/usr/local/opt/mysql-client/bin:$PATH"

  # export less flags
  export LESS="--quit-if-one-screen --hilite-search --hilite-unread --ignore-case --LONG-PROMPT --RAW-CONTROL-CHARS --chop-long-lines  --window=-4"

  # import the extra environment variable files
  EXTRAENVVARFILES=$(find "$HOME" \( -type l -o -type f \) -maxdepth 1 -iname ".zshenv.*" \! -iname ".zshenv.secure*")
  for ENVVARFILE in $EXTRAENVVARFILES; do
   source "$ENVVARFILE"
  done

  # import all extra secure environment variable files
  EXTRAENVVARSECUREFILES=$(find "$HOME" \( -type l -o -type f \) -maxdepth 1 -iname ".zshenv.secure.*")
  for ENVVARSECUREFILE in $EXTRAENVVARSECUREFILES; do
   source "$ENVVARSECUREFILE"
  done
fi
