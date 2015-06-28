# vim:autoindent:expandtab:ts=4
#
export EDITOR=vim
export VISUAL=vim
export BC_ENV_ARGS=~/.bcrc

if [[ $OSTYPE =~ 'darwin.*' ]]; then
    path=(/Library/Frameworks/Python.framework/Versions/2.7/bin $path)
    export PATH
fi
path=(~/bin /usr/local/go/bin /usr/local/bin /usr/local/sbin /usr/sbin /sbin $path)
export PATH

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


