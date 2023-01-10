# vim:autoindent:expandtab:ts=4
#
export EDITOR=vim
export VISUAL=vim
export BC_ENV_ARGS=~/.bcrc
export MAILCHECK=0

if [[ $OSTYPE =~ 'darwin.*' ]]; then
    export LANG=en_CA.UTF-8
fi
# force 24 hour clock in /bin/date
export LC_TIME=C

path=(/usr/local/bin /usr/local/sbin /usr/sbin /sbin $path)
export PATH

manpath=(/usr/share/man $manpath)
export MANPATH

if [[ -d /usr/local/go/bin ]]; then
    path=(/usr/local/go/bin $path)
fi

if [[ -d ~/bin/bind ]]; then
    path=(~/bin/bind/bin ~/bin/bind/sbin $path)
fi

if [[ -d ~/bin ]]; then
    path=(~/bin $path)
fi

if [[ -d /opt/mattermost/bin ]]; then
    path=(/opt/mattermost/bin $path)
fi

for dir in ~/Development ~/devel; do
    if [[ -d $dir ]]; then
        export GOPATH=$dir/go
        path=($GOPATH/bin $path)
        break
    fi
done


# Set up manpath for GPG on MacOS
if [[ -d /usr/local/MacGPG2/ ]]; then
    manpath=($manpath /usr/local/MacGPG2/share/man)
fi

# If we've got facter, this is a puppet managed box.  Set some variables we
# need for interacting with facter et. al.
if [[ -f /usr/local/bin/facter ]]; then
    export FACTERLIB=/var/opt/lib/pe-puppet/lib:/var/puppet/lib/facter/
fi
