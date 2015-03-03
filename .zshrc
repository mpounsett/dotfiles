# vim:autindent:expandtab:ts=4
#
export HISTSIZE=1000
export SAVEHIST=4000
export HISTFILE=~/.history

# Setup the SSH agent
ssh_agent_setup=0
if [[ -f ~/.ssh/agent ]]; then
    source ~/.ssh/agent
fi
if [[ -n "$SSH_AGENT_PID" ]]; then
    kill -0 $SSH_AGENT_PID >& /dev/null
    if [[ $? -eq 0 ]]; then
        ssh_agent_setup=1
    fi
fi
if [[ ssh_agent_setup -eq 0 ]]; then
    ssh-agent > ~/.ssh/agent
    cat ~/.ssh/agent
    source ~/.ssh/agent
    ssh-add ~/.ssh/rightside_rsa
    ssh-add ~/.ssh/conundrum_internal_rsa
fi

if [[ `echotc Co` -ge 8 ]]; then
	# there are 8 or more colours to work with
	PS1=$'\n%B%n%b@%B%F{green}%M%f%b:%F{cyan}%~%f\n%B%F{yellow}%*%f%b (%h) %# '
else
	PS1=$'\n%B%n%b@%B%M%b:%~\n%B%*%b (%h) %# '
fi

bindkey '\Ep' history-beginning-search-backward
bindkey '\En' history-beginning-search-forward

# ls and completion colours
#
zmodload zsh/complist
export ZLS_COLOURS="di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43"
export CLICOLOR=true
export LSCOLORS=gxfxExdxbxegedabagacad

