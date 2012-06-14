
umask 0022

test -n "$INTERACTIVE" && {

  # Suppress local mail notices
  shopt -u mailwarn >/dev/null 2>&1
  unset MAILCHECK

  # Do not try to complete when the command is empty/whitespace
  shopt -s no_empty_cmd_completion >/dev/null 2>&1

  # Append history to ~/.bash_history on shell exit
  shopt -s histappend >/dev/null 2>&1

  # --------------------------------------------------------------------
  # Prompt
  #
  # Bash escapes:
  #
  # \j    Number of jobs currently managed by the shell
  # \n    New line
  # \u    Username
  # \w    Current working directory
  # \W    Name of this directory (not full dir)
  # \\$   $ or # (depending on uid)
  # \[    Start of non-printing sequence (e.g. colors)
  # \]    End of non-printing sequence
  #
  # Environment variables:
  #
  # \$?   Exit value of last command executed (eval'd on each prompt)
  #
  # Functions:
  #
  # _xc <color>
  #     Sets a color.
  #
  # _xcb <color>
  #     Same as _xc(), but uses bold (bright) variant.
  #
  # _xcu <color>
  #     Same as _xc(), but uses underlined variant.
  #
  # _xcr
  #     Resets to default colors.
  #
  # _short_hname
  #     Returns a shortened version of local system name.
  #
  # _scm_color (escaped to eval on each prompt)
  #     Determines color for branch/repo type returned by _scm_info().
  #     All CVS/Subversion, and clean git, return cyan.
  #     Git with pending commits or other "dirty" state is red or yellow.
  #
  # _scm_info (escaped to eval on each prompt)
  #     Looks for code repositories. If git is found, branch name is shown.
  #     Git branches also show an arrow icon for state. Up arrow if the
  #     branch has commits pending push. Down arrow if the branch is
  #     behind and can be fast-forwarded. Double-headed arrow if the
  #     branch has gone into a diverged state.
  #     For CVS or Subversion directories, only the repo type is shown.
  #
  # _xc_retval (escaped to eval on each prompt)
  #     Returns a highlighted color if $? is non-zero.
  #
  # _xc_jobs (escaped to eval on each prompt)
  #     Returns a highlighted color if `jobs` lists 1 or more jobs.

  # iTerm2 and Apple Terminal support 256 colors. But, I am currently
  # using the Solarized Dark theme, which only cares about the default
  # 16 colors (though it remaps them in iTerm2 to its own shades).
  # Here are the base color codes for reference.
  #
  # 0 Reset all attrs         5 Blink
  # 1 Bright                  7 Reverse
  # 2 Dim                     8 Hidden
  # 4 Underscore
  #
  # Color         Fg  Bg
  # -----         --  --
  # Black         30  40
  # Red           31  41
  # Green         32  42
  # Yellow        33  43
  # Blue          34  44
  # Magenta       35  45
  # Cyan          36  46
  # White         37  47

  # Reset to default colors, then start a new line
  PS1="\[$(_xcr)\]\n"

  # Check for new mail (red envelope icon)
  PS1="$PS1\[$(_xc 31)\]\$(_check_for_mail)\[$(_xcr)\]"

  # Show current directory (violet)
  PS1="$PS1\[$(_xcb 35)\]\w\[$(_xcr)\]"

  # Show code repo (if present) in color, then start new line
  PS1="$PS1\[\$(_scm_color)\]\$(_scm_info)\[$(_xcr)\]\n"

  # Show {user}@{host}, magenta
  PS1="$PS1\[$(_xcu 35)\]\u@$(_short_hname)\[$(_xcr)\]"

  # Show the value of $? (in inverse red if it's non-zero)
  PS1="$PS1{\[\$(_xc_retval)\]\$?\[$(_xcr)\]}"

  # Show the current number of jobs (in red if > 0), then a prompt
  PS1="$PS1[\[\$(_xc_jobs)\]\j\[$(_xcr)\]]\\$ "

  export PS1

  # A decent tcsh prompt:
  #set prompt = "%n@%M:%c{%?}%# "

  stty erase "^?" -parenb -istrip echo echoe echoctl echoke tabs cs8

  # Keybindings for commandline edits (emacs or vi)
  set -o vi

  # notify of bg job completion immediately
  set -o notify

  set_tab_title $HOST

}

