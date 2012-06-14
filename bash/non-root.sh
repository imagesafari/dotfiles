
# Interactive sessions that are _not_ root do a few other things.
# The root check is so this isn't run again if i 'op' or 'sudo'.

test -n "$INTERACTIVE" -a "$UID" != "0" && {

  # I like to see load avg and uptime numbers
  uptime

  # Show me the local architecture
  echo
  echo -e ">> $(_xcu 36)$(uname -srm)$(_xcr)"
  echo

  # Check for broken services, if this is a Sun SMF-capable system
  test -x /bin/svcs && svcs -xv

  # Is X11 ready to go? If so let me know.
  test -n "$DISPLAY" -a "$OS" != "Darwin" && {
    echo
    echo "DISPLAY is set: $DISPLAY"
    echo
  }

  # Create some Vim cache directories if they don't exist.
  mkdir -p ~/.vim/tmp/{undo,backup,swap}

  # Check yankring permissions
  _yankring="$HOME/.vim/yankring_history_v2.txt"
  if [[ -f $_yankring ]]; then
    if [[ ! -O $_yankring ]]; then
      echo
      echo "    *** ----------------------------------------------- ***"
      echo "    *** WARNING: yankring history file is not writeable ***"
      echo "    *** ----------------------------------------------- ***"
      ls -l $_yankring
      echo
    else
      # It's present and I own it. Make sure permissions are good.
      chmod 0600 $_yankring
    fi
  else
    # It's not present. Proactively create and chown it.
    touch $_yankring
    chmod 0600 $_yankring
  fi

  test -n "$HAVE_SCREEN" && $HAVE_SCREEN -list | grep -v '^No Sockets'

  if [ -n "$HAVE_TMUX" -a -z "$TMUX" ]; then
    tmux ls 2>/dev/null
  fi

}

