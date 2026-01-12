# vim:autoindent:expandtab:ts=4

# Setup the SSH agent
if [[ -z "$SSH_TTY" && -z "$INTELLIJ_ENVIRONMENT_READER" ]]; then
    # First, check if ssh-agent is running already, and if it isn't start it
    # up.
    ssh_agent_setup=0
    if [[ -f ~/.ssh/agent ]]; then
        source ~/.ssh/agent
    fi
    if [[ -n "$SSH_AGENT_PID" ]]; then
        kill -0 $SSH_AGENT_PID >& /dev/null
        if [[ $? -eq 0 ]]; then
            pid_comm=`ps -p $SSH_AGENT_PID -o comm | tail -1`
            if [[ $pid_comm =~ 'ssh-agent$' ]]; then
                ssh_agent_setup=1
            fi
        fi
    fi
    if [[ ssh_agent_setup -eq 0 ]]; then
        ssh-agent > ~/.ssh/agent
        cat ~/.ssh/agent
        source ~/.ssh/agent
    fi
    # And then check whether there are any identities added, because ssh-agent
    # may have been auto-started by MacOS on boot, in which case it's running
    # but empty.
    ids=$(ssh-add -l | head -1)
    if [[ $ids =~ 'no identities.$' ]]; then
        if [[ -f ~/.ssh/conundrum ]]; then
            ssh-add ~/.ssh/conundrum
        fi
        if [[ -f ~/.ssh/oarc ]]; then
            ssh-add ~/.ssh/oarc
        fi
        if [[ -f ~/.ssh/conundrum-github ]]; then
            ssh-add ~/.ssh/conundrum-github
        fi
        if [[ -f ~/.ssh/isc-gitlab ]]; then
            ssh-add ~/.ssh/isc-gitlab
        fi
    fi
fi

# Set the directory where zinit and plugins should be stored
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if it's not already there
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# And run it
source "${ZINIT_HOME}/zinit.zsh"

# zinit plugins
zinit ice depth=1; zinit light romkatv/powerlevel10k

# zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# add snippets
zinit snippet OMZP::command-not-found

# Load completions
autoload -U compinit && compinit
zinit cdreplay -q

# Set up the Powerlevel10k instant prompt.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#
# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=${HISTSIZE}
HISTDUP=erase
setopt SHARE_HISTORY
## implied by SHARE_HISTORY
# setopt INC_APPEND_HISTORY
# setopt EXTENDED_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

bindkey '\Ep' history-beginning-search-backward
bindkey '\En' history-beginning-search-forward

# zmv for magic file renames
autoload -Uz zmv
alias zcp='zmv -C'  # Copy with patterns
alias zln='zmv -L'  # Link with patterns

# edit command prompt using $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# magic space expands shell history variables like !!
bindkey ' ' magic-space

# rebuild the current input buffer after clearing the screen and scrollback
# buffer
function clear-screen-and-scrollback() {
    echoti civis >"$TTY"
    printf '%b' '\e[H\e[2J\e[3J' >"$TTY"
    echoti cnorm >"$TTY"
    zle .reset-prompt
}
zle -N clear-screen-and-scrollback
bindkey '^Xl' clear-screen-and-scrollback


# pbcopy the current command buffer to clipboard (MacOS)
if [ ! -z $(whence pbcopy) ]; then
    function copy-buffer-to-clipboard() {
        echo -n "$BUFFER" | pbcopy
        zle -M "Copied to clipboard"
    }
    zle -N copy-buffer-to-clipboard
    bindkey '^Xc' copy-buffer-to-clipboard
fi


if [[ $OSTYPE =~ 'darwin.*' ]]; then
    function connerize() { echo "$*" | sed "s/s/sh/g" }
    function connerize-say() { echo "$*" | sed 's/s/sh/g' | say -v "Alex" -i -r 200 }
fi

# downloading files with the proper output file name for sites that don't
# implement Content-Disposition.
fncurl () {
    fn=`curl -sI "$@" | grep 'location:' | awk -F/ '{print $NF}' | sed 's/\r//'`
    curl -o $fn -L $@
}

# Use this for rollbacks:
# apt-get -s install $(apt-history rollback | tr '\n' ' ')
apt-history () {
case "$1" in
    help)
        cat << END
        install - search for recently installed packages
        upgrade|remove - search for recently upgraded or removed packages
        rollback [from] [to] - show rollback data for all packages upgraded
                               between dates 'from' and 'to'
END
        ;;
    install)
        cat /var/log/dpkg.log | grep 'install '
        ;;
    upgrade|remove)
        cat /var/log/dpkg.log | grep $1
        ;;
    rollback)
        cat /var/log/dpkg.log | grep upgrade | \
            grep "$2" -A10000000 | \
            grep "$3" -B10000000 | \
            awk '{print $4"="$5}'
        ;;
    *)
        cat /var/log/dpkg.log
        ;;
esac
}

waitfor() {
    until ! ping -c1 "$1" >/dev/null 2>&1; do sleep 1; done
    until ping -c1 "$1" >/dev/null 2>&1; do sleep 1; done
}

if [[ $OSTYPE =~ 'darwin.*' ]]; then
    sayready() {
        if [[ -z "$2" ]]; then
            waitfor "$1" && say "Ready $1"
        else
            waitfor "$1" && say "Ready $2"
        fi
    }
fi



if [[ $OSTYPE =~ 'darwin.*' ]]; then
    # Inspired by https://gist.github.com/bashbunni/f6b04fc4703903a71ce9f70c58345106
    # requires:
    # - https://github.com/caarlos0/timer
    # - https://github.com/julienXX/terminal-notifier
    #
    POMO_WORKMSG="Work timer is up! Take a break."
    POMO_WORKTIME=60m
    POMO_RESTMSG="Break is over!  Time to get back to work."
    POMO_RESTTIME=10m
    POMO_SOUND=Submarine
    POMO_OPTIONS=(-title Pomodoro -sound ${POMO_SOUND})
    POMO_DATE=(date "+%H:%M")
    alias work="timer -n Work ${POMO_WORKTIME} && \
        terminal-notifier ${POMO_OPTIONS} \
        -message '\[$(${POMO_DATE})] ${POMO_WORKMSG}'"
    alias rest="timer -n Rest ${POMO_RESTTIME} && \
        terminal-notifier ${POMO_OPTIONS} \
        -message '\[$(${POMO_DATE})] ${POMO_RESTMSG}'"
fi



# Force ls to colour mode all the time
if [[ $OSTYPE =~ 'darwin.*' ]]; then
    alias ls='ls -G'
elif [[ $OSTYPE =~ 'freebsd.*' ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color'
fi

if [[ -n `whence pyenv` ]]; then
    export WORKON_HOME=~/.ve
    export PROJECT_HOME=~/devel
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
    eval "$(pyenv init -)"
    pyenv virtualenvwrapper_lazy
fi

# NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


# ls and completion colours
#
zmodload zsh/complist
export ZLS_COLORS="di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43"
export LS_COLORS="di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43"
export CLICOLOR=true
export LSCOLORS=gxfxExdxbxegedabagacad

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fzf shell integration
if [ ! -z "$(whence fzf)" ]; then
    eval "$(fzf --zsh)"
fi

# zoxide
if [ ! -z "$(whence zoxide)" ]; then
    eval "$(zoxide init --cmd cd zsh)"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
