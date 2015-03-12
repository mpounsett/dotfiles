# vim:autoindent:expandtab:ts=4
#
export HISTSIZE=1000
export SAVEHIST=4000
export HISTFILE=~/.history
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_REDUCE_BLANKS
setopt PROMPT_SUBST

if [[ $OSTYPE =~ 'darwin.*' ]]; then
    function connerize() { echo "$*" | sed "s/s/sh/g" }
    function connerize-say() { echo "$*" | sed 's/s/sh/g' | say -v "Alex" -i -r 200 }
fi


# Setup the SSH agent
if [[ -z "$SSH_TTY" ]]; then
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
fi

git_prompt() {
    git branch > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        # we're in a git branch
        branch=`git branch 2> /dev/null | cut -d" " -f2`
        git status | grep "nothing to commit" > /dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            # clean repository
            colour='green'
            sep=('[' ']')
        else
            # stuff to commit
            colour='red'
            sep=('{' '}')
        fi
        printf " %%F{$colour}$sep[1]$branch$sep[2]%%f"
    else
        # not in a git repo
    fi
}

python_inc=(`python -c 'import site; print " ".join(site.getsitepackages())'`)>&/dev/null
powerline_setup=0
for py_path in $python_inc; do
    if [[ -f "${py_path}/powerline/bindings/zsh/powerline.zsh" ]]; then
        #powerline-daemon -q
        . "${py_path}/powerline/bindings/zsh/powerline.zsh"
        powerline_setup=1
        break
    fi
done
if [[ $powerline_setup -eq 0 ]]; then
    if [[ `echotc Co` -ge 8 ]]; then
	    # there are 8 or more colours to work with
        PS1=$'\n%B%n%b@%B%F{green}%M%f%b:%F{cyan}%~%f\n%B%F{yellow}%*%f%b$(git_prompt) (%h) %# '
    else
        PS1=$'\n%B%n%b@%B%M%b:%~\n%B%*%b$(git_prompt) (%h) %# '
    fi
fi

bindkey '\Ep' history-beginning-search-backward
bindkey '\En' history-beginning-search-forward

# ls and completion colours
#
zmodload zsh/complist
export ZLS_COLOURS="di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43"
export CLICOLOR=true
export LSCOLORS=gxfxExdxbxegedabagacad

if [[ -f /usr/local/bin/virtualenvwrapper.sh ]]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi
