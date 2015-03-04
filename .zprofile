
# if we haven't recently done a git fetch, do that, then check on how far
# ahead/behind the dotfiles repo is.
#
pushd -q ~/etc/dotfiles
last=`stat -f '%m' .git/FETCH_HEAD`
now=`date +'%s'`
echo -n "dotfiles: "
if [[ $(( $last + 86400 )) -lt $now ]]; then
	git fetch
fi
git for-each-ref refs/heads --format='%(refname:short) %(upstream:track)'
popd -q
