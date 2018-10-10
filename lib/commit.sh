# cb - current branch
# c - commit id
# t - tree
# m - commit message
# pc - previous commit id
commit() {
  cb=`cbranchfn`
  read -p "Commit message: " m

  t=`git write-tree`
  if [ -z "${t}" ]; then
    echo $white"Something wrong when created tree"$white
    failfn 1
  fi
  echo $cyan"Tree"$white" $t created successfully"$white

  pc=`cat $heads/$cb 2> /dev/null`
  [[ "${?}" == "0" ]] \
    && c=`echo "$m" | git commit-tree $t -p $pc` \
    || c=`echo "$m" | git commit-tree $t`
  if [ -z "${c}" ]; then
    echo $white"Something wrong when created commit"$white
    failfn 1
  fi
  echo $cyan"Commit"$white" $c created successfully"$white

  `git update-ref refs/heads/$cb $c`
  echo $cyan"Ref"$white" $cb updated successfully"$white

  okfn
}
