# vim:autoindent:expandtab:ts=4
#
PATH="~/bin:/usr/local/bin:/usr/local/sbin:/usr/sbin:/sbin:${PATH}"
EDITOR=vim
VISUAL=vim

if [[ `echotc Co` -ge 8 ]]; then
	# there are 8 or more colours to work with
	PS1=$'\n%B%n%b@%B%F{green}%M%f%b:%F{cyan}%~%f\n%B%F{yellow}%*%f%b (%h) %# '
else
	PS1=$'\n%B%n%b@%B%M%b:%~\n%B%*%b (%h) %# '
fi

bindkey '\Ep' history-beginning-search-backward
bindkey '\En' history-beginning-search-forward
