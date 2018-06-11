# vim:autoindent:expandtab:ts=4
#
export HISTSIZE=1000
export SAVEHIST=4000
export HISTFILE=~/.zsh_history

setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_REDUCE_BLANKS
setopt PROMPT_SUBST


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

# Force ls to colour mode all the time
if [[ $OSTYPE =~ 'darwin.*' ]]; then
    alias ls='ls -G'
elif [[ :$OSTYPE =~ 'freebsd.*' ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color'
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
        if [[ -f ~/.ssh/rightside_rsa ]]; then
            ssh-add ~/.ssh/rightside_rsa
        fi
        if [[ -f ~/.ssh/conundrum_internal_rsa ]]; then
            ssh-add ~/.ssh/conundrum_internal_rsa
        fi
        if [[ -f ~/.ssh/conundrum_external_rsa ]]; then
            ssh-add ~/.ssh/conundrum_external_rsa
        fi
        if [[ -f ~/.ssh/conundrum-codebase ]]; then
            ssh-add ~/.ssh/conundrum-codebase
        fi
    fi
fi

# pyenv/virtualenv setup
if [[ -x "${HOME}/.pyenv/bin/pyenv" ]]; then
    export PYENV_ROOT="${HOME}/.pyenv"
    path=(${PYENV_ROOT}/bin $path)
fi

if [[ -n `whence pyenv` ]]; then
    export WORKON_HOME=~/.ve
    export PROJECT_HOME=~/devel
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    eval "$(pyenv init -)"
    pyenv virtualenvwrapper_lazy
fi

git_prompt() {
    git branch > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        # we're in a git branch
        branch=`git branch 2> /dev/null | cut -d" " -f2 | tr -d '\n' `
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

# Setting up Powerline-Status
#
# First, let's see if powerline is installed in a pyenv
pline_zsh=""
if [[ -n `whence pyenv` ]]; then
    powerline_loc=`pyenv which powerline`
    if [[ $? -eq 0 ]]; then
        # We've got a location for powerline.. strip of bin/powerline and that
        # gives us a path we can start looking in for powerline.zsh
        pyenv_path=${powerline_loc%"bin/powerline"}
        pline_zsh=`find $pyenv_path -name powerline.zsh 2>&/dev/null`
    fi
else
    # pyenv isn't installed, or it is installed and doesn't have powerline in
    # any of its venvs.  Let's see if the default python can find it.
    python_inc=(`python -c 'import site; print(" ".join(site.getsitepackages()))'`)>&/dev/null
    for py_path in $python_inc; do
        if [[ -d py_path ]]; then
            check_path=`find $py_path -name powerline.zsh`
            if [[ -n $check_path ]]; then
                pline_zsh=$check_path
            fi
        fi
    done
fi

if [[ $NOPOWERLINE != "" && -f "${pline_zsh}" ]]; then
    # powerline-daemon found to be slow and crashy
    # powerline-daemon -q
    . "${pline_zsh}"
else
    # We don't have powerline.  Set up a custom shell prompt.
    #
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
export ZLS_COLORS="di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43"
export LS_COLORS="di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43"
export CLICOLOR=true
export LSCOLORS=gxfxExdxbxegedabagacad

for f in /usr/local/bin/virtualenvwrapper.sh /usr/bin/virtualenvwrapper.sh; do
    if [[ -f $f ]]; then
        source $f
        break
    fi
done

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
