autoload -U bashcompinit && bashcompinit

source "$HOME/.functions.zsh"

source-if-exists "$(brew --prefix)/etc/profile.d/z.sh"
source-if-exists "$HOME/.zprezto/init.zsh"
source-if-exists "$HOME/.iterm2_shell_integration.zsh"
source-if-exists "$HOME/.travis/travis.sh"

eval "$(grit shell-integration)"

ssh-add -A 2>/dev/null

alias e='code .'
alias h='hive'
alias d='docker'
alias m='make'

alias less='less -R'
alias grep='grep --color'

alias top='top -F -o cpu -O vsize'
alias mc='EDITOR=code mc'
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias iplocal="ipconfig getifaddr en0"
alias network.connections='lsof -l -i +L -R -V'
alias network.established='lsof -l -i +L -R -V | grep ESTABLISHED'

if [[ "$(uname)" == "Darwin" ]]; then
    alias ls='ls -lhG'
else
    alias ls='ls -lh --color --group-directories-first'
fi


setopt clobber
unsetopt autocd
unsetopt correct
