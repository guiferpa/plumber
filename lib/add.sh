add() {
  blob=`git hash-object -w $2`
  if [ -z "${blob}" ]; then
    echo $white"Something wrong when create blob"$white
    failfn 1
  fi

  if [ -f "${2}" ]; then
    `git update-index --add --cacheinfo 100644 $blob $2`
  fi

  echo $cyan"Blob$white $blob as $2 added in index"
  okfn
}
