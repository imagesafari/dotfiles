
test -n "$INTERACTIVE" && {

  # Use color? Set to 'no' or 'yes'. If active, the default choice in a
  # multi-item match will be highlighted with terminal colors. If no,
  # colors are omitted. The default choice will still be highlighted
  # by having a "*" printed next to it.
  #
  USE_PROJCOLOR="yes"

  # Color definitions
  if [[ "$USE_PROJCOLOR" = "yes" ]]; then
    _projcolor="\033[0;31;47m"
    _projcolor_clear="\033[0m"
  fi

  # Get a list of projects. An optional pattern can be supplied.
  _get_projects() {
    local _pattern="$1"
    local _line

    projls -ltr | while read -r _line; do
      set -- $_line
      test -d "$9" && {
        [[ "$9" =~ ^[0-9]{8}-.*$_pattern ]] && echo $9
      }
    done
  }

  # Get a sorted list of projects. Sort by date (i.e. numerically)
  _get_projects_sorted() {
    local _pattern="$1"
    _get_projects "$_pattern" | sort -n
  }

  # Get a count of projects. Optionally supply a pattern.
  _get_project_count() {
    local _pattern="$1"
    local _count=0
    local _project

    for _project in `_get_projects "$_pattern"`; do
      _count=$((_count + 1))
    done

    echo $_count
  }

  # Get the newest project (by mtime).
  _get_current_project() {
    local _project
    local _current

    for _project in `_get_projects`; do
      _current="$_project"
    done

    echo $_current
  }

  # Choose the project from a menu
  _get_project_from_menu() {
    local _pattern="$1"
    local _count=0
    local _index=0
    local _matches
    local _project

    # Get the name of the current project, to use as the default.
    local _default=`_get_current_project`
    local _seen_default

    # Get a date-sorted list of projects, put it in an array.
    for _project in `_get_projects_sorted "$_pattern"`; do
      _index=$((_index + 1))
      _count=$((_count + 1))
      _matches[$_index]="$_project"
    done

    # Show a menu of available matches
    _index=0
    for _project in ${_matches[@]}; do
      _index=$((_index + 1))
      if [[ "$_project" = "$_default" ]]; then
        echo -e "$_projcolor* [$_index] $_project$_projcolor_clear"
        _seen_default="yes"
      elif [[ $_index -eq $_count && "$_seen_default" != "yes" ]]; then
        echo -e "$_projcolor* [$_index] $_project$_projcolor_clear"
        _default="$_project"
      else
        echo "  [$_index] $_project"
      fi
    done

    # Collect a choice. No choice means to use the default choice.
    # If the choice was null, back off one from the index.
    echo -n "=> "
    read _choice

    test -z "$_choice" && { cd $_default; return; }

    if [[ $_choice -lt 1 || $_choice -gt ${#_matches[@]} ]]; then
      echo "Out of range"
      return
    fi

    _project=${_matches[$_choice]}
    test -n "$_project" && cd $_project
  }

  # Create a project directory with the current date and a label,
  # e.g. 20100904-openssh-upgrade. Optionally supply a ticket number to
  # be inserted after the date, e.g. 20100904-29714-openssh-upgrade.

  mkproj() {
    local _usage="Usage: mkproj <description> [<ticket>]"
    local _description="$1"
    local _ticket="$2"
    local _date
    local _directory

    if [[ "$_description" =~ ^\(-h\|--help\) ]]; then
      echo $_usage
      return
    fi

    _date=`date +"%Y%m%d"`

    if test -n "$_ticket"; then
      _directory="$_date-$_ticket-$_description"
    elif test -n "$_description"; then
      _directory="$_date-$_description"
    else
      echo $_usage
      return
    fi

    mkdir ~/$_directory && cd ~/$_directory
  }

  # Find a project. If only one project matches, go there. If multiple do,
  # print a list for user to select from. Hit enter to choose the default
  # (*'d) choice automatically.

  proj() {
    local _usage="Usage: proj [<pattern>]"
    local _pattern="$1"
    local _count
    local _project

    if [[ "$_pattern" =~ ^\(-h\|--help\) ]]; then
      echo $_usage
      return
    fi

    cd ~

    # if no pattern is given, go to the newest project (by mtime).
    test -z "$_pattern" && {
      _project=`_get_current_project`
      test -n "$_project" && cd $_project || echo "No match."
      return
    }

    # Get a count of projects (by pattern match).
    _count=`_get_project_count "$_pattern"`

    # Case 1: there aren't any.
    if [[ $_count -eq 0 ]]; then
      echo "No match."
      return

    # Case 2: there's only one. Go there automatically.
    elif [[ $_count -eq 1 ]]; then
      cd `_get_projects "$_pattern"`

    # Case 3: catch-all. Pick from a menu.
    else
      _get_project_from_menu "$_pattern"
    fi
  }
}

