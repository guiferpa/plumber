staged_or_diff_all_status() {
  local files=`git ls-files -s | awk '{ print $4 }'`
  local mfiles=`git ls-files -m`
  echo "Already staged files with reference to unstaged modifications:\n"
  for file in $files; do
    local cblob=`git ls-files -s | grep -w $file | awk '{ print $2 }'`
    if [[ $mfiles == *"$file"* ]]; then
      local nblob=`git hash-object $file`
      echo "$file $cblob $nblob" | \
        awk '{ printf "'$cyan' %s'$white' %s <- '$red'%s'$white'\n", $1, $2, $3 }'
    else
      echo "$file $cblob" | \
        awk '{ printf "'$cyan' %s'$white' %s\n", $1, $2 }'
    fi
  done | column -t
}

staged_or_diff_status() {
  local files=`git ls-files -s | awk '{ print $4 }'`
  local mfiles=`git ls-files -m`
  echo "Already staged files with reference to unstaged modifications:\n"
  for file in $files; do
    local cblob=`git ls-files -s | grep -w $file | awk '{ print $2 }'`
    if [[ $mfiles == *"$file"* ]]; then
      local nblob=`git hash-object $file`
      echo "$file $cblob $nblob" | \
        awk '{ printf "'$cyan' %s'$white' %s <- '$red'%s'$white'\n", $1, $2, $3 }'
    fi
  done | column -t
}

untracked_status() {
  echo "Untracked not staged for commit:\n"
  git ls-files -o --exclude-standard 2> /dev/null | \
    awk '{ printf "'$red' %s'$white'\n", $1 }' | column -t
}

status() {
  local stage=`git ls-files -s`
  local untracked=`git ls-files -o --exclude-standard`
  if [ ! -z "${stage}" ]; then
    if [ "${1}" = "--all" ]; then
      staged_or_diff_all_status && echo "\n"
    else
      staged_or_diff_status && echo "\n"
    fi
  fi
  [ ! -z "${untracked}" ] && untracked_status && echo "\n"
  okfn
}
