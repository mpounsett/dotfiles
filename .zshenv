# vim:autoindent:expandtab:ts=4
#
export EDITOR=vim
export VISUAL=vim
export BC_ENV_ARGS=~/.bcrc

if [[ $OSTYPE =~ 'darwin.*' ]]; then
    export LANG en_CA.UTF-8
fi

path=(/usr/local/bin /usr/local/sbin /usr/sbin /sbin $path)
export PATH

if [[ -d /usr/local/go/bin ]]; then
    path=(/usr/local/go/bin $path)
fi

if [[ -d ~/bin/bind ]]; then
    path=(~/bin/bind/bin ~/bin/bind/sbin $path)
fi

if [[ -d ~/bin ]]; then
    path=(~/bin $path)
fi

for dir in ~/Development ~/devel; do
    if [[ -d $dir ]]; then
        export GOPATH=$dir/go
        path=($GOPATH/bin $path)
        break
    fi
done

if [[ -d /Users/matthewpounsett/Library/Python/2.7/bin ]]; then
    path=($path /Users/matthewpounsett/Library/Python/2.7/bin)
fi

# If we've got facter, this is a puppet managed box.  Set some variables we
# need for interacting with facter et. al.
if [[ -f /usr/local/bin/facter ]]; then
    export FACTERLIB=/var/opt/lib/pe-puppet/lib:/var/puppet/lib/facter/
fi


