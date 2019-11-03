# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# Golang-related environment variables
export GOPATH="$HOME/go"
export GOPROXY="direct"
export GOSUMDB="off"


# local bin and GOBIN path
export PATH="$HOME/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"


