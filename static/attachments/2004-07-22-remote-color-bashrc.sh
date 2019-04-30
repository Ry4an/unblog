# make the center atsign highlighted if remote
TTY=$(tty)
TTY=$(echo $TTY | sed 's/\/dev\///')
if w -hu | grep -q $TTY ; then
    #echo is remote
    ISREMOTE=true
    ATSIGN="\[\e[30;47m\]@\[\e[0m\]"
else
    #echo is local
    ISLOCAL=true
    ATSIGN=@
fi

# host has color 31;1 which is bright red
if [ `id -u` -eq 0 ]; then   # if root
    PS1="\n[\[\e[30;41m\]\u\[\e[0m\]$ATSIGN\[\e[31;1m\]\h\[\e[0m\] \w]\$ "
else
    PS1="\n[\u$ATSIGN\[\e[31;1m\]\h\[\e[0m\] \w]\$ "
fi
