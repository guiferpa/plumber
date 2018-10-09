commit() {
  cb=`cat .git/HEAD | awk '{print substr($2, 12, length($2))}'`
  echo "Write a commit message?"
  read m

  t=`git write-tree`
  if [ -z "${t}" ]; then
    echo $white"Something wrong when created tree"$white
    failfn 1
  fi
  echo $cyan"Tree"$white" $t created successfully"$white

  c=`echo "$m" | git commit-tree $t`
  if [ -z "${c}" ]; then
    echo $white"Something wrong when created commit"$white
    failfn 1
  fi
  echo $cyan"Commit"$white" $c created successfully"$white

  `git update-ref refs/heads/$cb $c`
  echo $cyan"Ref"$white" $cb updated successfully"$white

  okfn
}
