# vim:autoindent:expandtab:ts=4
#
# add to end of path
alias append_path 'if ( $\!:1 !~ \!:2\:* && $\!:1 !~ *\:\!:2\:* && $\!:1 !~ *\:\!:2 && $\!:1 !~ \!:2 ) setenv \!:1 ${\!:1}\:\!:2'
# need to figure out how to replace the sed references in here with variables,
# safely.
if (-f /usr/bin/sed) then
    # add to front of path
    alias prepend_path 'if ( $\!:1 !~ \!:2\:* && $\!:1 !~ *\:\!:2\:* && $\!:1 !~ *\:\!:2 && $\!:1 !~ \!:2 ) setenv \!:1 \!:2\:${\!:1}; if ( $\!:1 !~ \!:2\:* ) setenv \!:1 \!:2`echo \:${\!:1} | /usr/bin/sed -e s%^\!:2\:%% -e s%:\!:2\:%:%g -e s%:\!:2\$%%`'
else
    # add to front of path
    alias prepend_path 'if ( $\!:1 !~ \!:2\:* && $\!:1 !~ *\:\!:2\:* && $\!:1 !~ *\:\!:2 && $\!:1 !~ \!:2 ) setenv \!:1 \!:2\:${\!:1}; if ( $\!:1 !~ \!:2\:* ) setenv \!:1 \!:2`echo \:${\!:1} | /bin/sed -e s%^\!:2\:%% -e s%:\!:2\:%:%g -e s%:\!:2\$%%`'
endif

unalias cwdcmd

if ( $OSTYPE == 'linux' ) then
    alias ls 'ls --color=auto'
endif
