# Bash function library, for use in scripts

# ----------------------------------------------------------------------
# yn <default> <question>
#
# Gets a yes/no answer and returns 0 for yes, nonzero for no. Therefore
# you can test for yes/no using && and || operators.
#
# Examples:
#
# yn y "Do you want to continue?" || exit
# yn n "Remove $FILE?" && rm -f $FILE

yn() {
  local _default="$1"
  local _question="$2"
  local _choice

  test -z "$_question" && {
    echo "ERROR: yn() is missing an argument"
    exit
  }

  echo -n "$_question "

  if [[ "$_default" = "y" || "$_default" = "Y" ]]; then
    echo -n "[Y/n] "
  elif [[ "$_default" = "n" || "$_default" = "N" ]]; then
    echo -n "[y/N] "
  else
    echo "ERROR: Invalid default for yn()"
    exit
  fi

  read _choice

  test -z "$_choice" && _choice="$_default"

  if [[ "$_choice" = "y" || "$_choice" = "Y" ]]; then
    return 0
  elif [[ "$_choice" = "n" || "$_choice" = "N" ]]; then
    return 1
  else
    echo "Invalid choice."
    exit
  fi

}

# ----------------------------------------------------------------------

