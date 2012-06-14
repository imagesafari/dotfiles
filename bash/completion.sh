
test -n "$INTERACTIVE" && {

  # Hostname completion using ssh known_hosts file

  shopt -s progcomp

  _compile_hosts() {
    local _cur
    local _ssh
    local _hfile
    local _hlocfile
    local _hosts
    local _lochosts

    # Look at the contents of SSH's known_hosts file
    # test -f ~/.ssh/known_hosts &&
      # _ssh="`cat ~/.ssh/known_hosts|cut -f 1 -d ' '|sed -e 's/,.*//g'|uniq|grep -v "\["`"

    # If there is a work-style .hostlist file handy, read that too
    test -f /admin/.hostlist && _hfile="/admin/.hostlist"
    test -f $HOME/.hostlist && _hfile="$HOME/.hostlist"
    unset _hosts
    test -n "$_hfile" && _hosts="`cat $_hfile`"

    # Also look for a local instance
    test -f $HOME/.hostlist.local && _hlocfile="$HOME/.hostlist.local"
    unset _lochosts
    test -n "$_hlocfile" && _lochosts="`grep -v '^#' $_hlocfile`"

    COMPREPLY=()
    _cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W '$( echo $_ssh $_hosts $_lochosts )' -- $_cur))
    return 0
  }

  complete -o default -F _compile_hosts \
    ssh sftp scp sdist host dig nslookup ping telnet mtr traceroute \
    cons clogin load seed for sshx sperl ping6 traceroute6

}

