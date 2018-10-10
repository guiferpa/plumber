# cc - current commit id
checkout_cfromcommit() {
  local cc=`git show-ref --head | grep HEAD | awk '{print $1}'`
  echo $cc > $heads/$1
  echo "ref: refs/heads/$1" > $head
  echo "Switched to branch: "$cyan"$1"$white" from $cyan"$cc$white
  okfn
}

checkout() {
  if [ "${2}" == "-b" ]; then
    checkout_cfromcommit $3
  fi
  echo "ref: refs/heads/$2" > $head
  echo "Switched to branch: "$cyan"$2"$white
  okfn
}
