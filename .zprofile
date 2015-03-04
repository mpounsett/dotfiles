
pushd ~/etc/dotfiles
git fetch
echo -n "dotfiles: "
git for-each-ref refs/heads --format='%(refname:short) %(upstream:track)'
