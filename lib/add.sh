# b - blob
add() {
  b=`git hash-object -w $2`
  if [ -z "${b}" ]; then
    echo $white"Something wrong when created blob"$white
    failfn 1
  fi

  if [ -f "${2}" ]; then
    `git update-index --add --cacheinfo 100644 $b $2`
  fi

  echo $cyan"Blob$white $b as $2 added in index"
  okfn
}
