
# if we haven't recently done a git fetch, do that, then check on how far
# ahead/behind the dotfiles repo is.  But only for a recent enough version of
# git.
#
check-refs () {
	if [[ `git --version | cut -d" " -f3 | cut -d"." -f1-2` -ge 1.9 ]]; then
		if [[ `uname` == 'Linux' ]]; then
			stat=(stat -c "%Y")
		else
			stat=(stat -f "%m")
		fi

		if [ -d "$2" ]; then
			echo -n "[$1]: "
			pushd -q "$2"
			last=`${stat} .git/FETCH_HEAD`
			now=`date +'%s'`
			if [[ $(( $last + 86400 )) -lt $now ]]; then
				git fetch > /dev/null 2>&1
			fi
			git for-each-ref refs/heads --format='%(refname:short) %(upstream:track)'
			popd -q
		fi
	fi
}

check-refs dotfiles ~/etc/dotfiles
check-refs pyenv ~/.pyenv/

ssh-key-remove () {
       host $1 | awk 'NR==1{print $1}; /address/ {print $NF}' | \
               xargs -n 1 ssh-keygen -R
}

if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# pyenv/virtualenv setup
if [[ -x "${HOME}/.pyenv/bin/pyenv" ]]; then
    export PYENV_ROOT="${HOME}/.pyenv"
    path=(${PYENV_ROOT}/bin $path)
	eval "$(pyenv init --path)"
fi

