# cb - current branch
# c - commit id
# t - tree
# m - commit message
# pc - previous commit id
commit() {
  local cb=`cbranchfn`
  read -p "Commit message: " m

  local t=`git write-tree`
  if [ -z "${t}" ]; then
    echo $white"Something wrong when created tree"$white
    failfn 1
  fi
  echo $cyan"Tree"$white" $t created successfully"$white

  local pc=`cat $heads/$cb 2> /dev/null`
  if [ -z "${pc}" ]; then
    local c=`echo "$m" | git commit-tree $t 2> /dev/null`
  else
    echo $cyan"Previous commit"$white" $pc got successfully"$white
    local c=`echo "$m" | git commit-tree $t -p $pc 2> /dev/null`
  fi

  if [ -z "${c}" ]; then
    echo $white"Something wrong when created commit"$white
    failfn 1
  fi
  echo $cyan"Commit"$white" $c created successfully"$white

  `git update-ref refs/heads/$cb $c`
  echo $cyan"Ref"$white" $cb updated successfully"$white

  okfn
}
