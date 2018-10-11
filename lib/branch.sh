switch_branch () {
  `cat $heads/$1 > /dev/null 2> /dev/null`
  if [ "${?}" != "0" ]; then
    warnfn "Branch "$cyan"$1"$white" is not forked from nowhere"
  fi
  echo "$rheads/$1" > $head
  echo "Switched to branch: "$cyan"$1"$white
  okfn
}

# cb - current branch
delete_branch() {
  local cb=`cat $head | awk '{print substr($2, 12, length($2))}'`
  if [ "${1}" == "${cb}" ]; then
    echo "Cannot delete branch "$cyan"$1"$white
    failfn 1
  fi
  `cat $heads/$1 > /dev/null 2> /dev/null`
  if [ "${?}" != "0" ]; then
    echo "Branch "$cyan"$1"$white" not found"
    failfn
  fi
  rm -rf $heads/$2
  echo "Deleted branch: "$cyan"$1"$white
  okfn
}

# cc - current commit id
fork_branch() {
  local cc=`git show-ref --head | grep HEAD | awk '{print $1}'`
  if [ -z "${cc}" ]; then
    echo "No exists commit reference to fork"
    failfn 1
  fi
  `cat $heads/$1 > /dev/null 2> /dev/null`
  if [ "${?}" == "0" ]; then
    warnfn "Branch "$cyan"$1"$white" already exists"
    while true; do
      read -p "Do you wish to override this branch (y/n)? " answer
      case $answer in
          [Yy]* ) break;;
          [Nn]* ) echo "Override of branch "$cyan$1$white" aborted"; failfn;;
          * ) echo "Please answer y or n.";;
      esac
    done
  fi
  echo $cc > $heads/$1
  echo "Branch "$cyan"$1"$white" forked from $cyan"$cc$white" created successfully"
  switch_branch $1
}

# fmt - format
show_branch() {
  local fmt="%(if)%(HEAD)%(then)$cyan* $white%(else)%(end)%(refname:short) -> %(objecttype):%(objectname)"
  git for-each-ref --format="$fmt" refs/heads/ | column
  okfn
}

branch() {
  [[ -z "${1}" ]] && show_branch
  [[ "${1}" == "--fork" ]] && fork_branch $2
  [[ "${1}" == "--delete" ]] && delete_branch $2
  switch_branch $1
  okfn
}
