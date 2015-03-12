
# if we haven't recently done a git fetch, do that, then check on how far
# ahead/behind the dotfiles repo is.  But only for a recent enough version of
# git.
#
if [[ `git --version | cut -d" " -f3 | cut -d"." -f1-2` -ge 1.9 ]]; then
	if [[ `uname` == 'Linux' ]]; then
		stat=(stat -c "%Y")
	else
		stat=(stat -f "%m")
	fi
	
	pushd -q ~/etc/dotfiles
	last=`${stat} .git/FETCH_HEAD`
	now=`date +'%s'`
	echo -n "dotfiles: "
	if [[ $(( $last + 86400 )) -lt $now ]]; then
		git fetch > /dev/null 2>&1
	fi
	git for-each-ref refs/heads --format='%(refname:short) %(upstream:track)'
	popd -q
fi
