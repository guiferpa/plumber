branch() {
  cb=`cat .git/HEAD | awk '{print substr($2, 12, length($2))}'`
  bs=`ls $gitf/refs/heads`
  echo "Current branch: "$cyan"$cb"$white
  if [ ! -z "${bs}" ]; then
    echo "List of branch:"
    for b in $bs; do echo " - $b"; done
  fi
  okfn
}
