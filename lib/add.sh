# b - blob
add() {
  for a in $@; do
    `cat $a > /dev/null 2> /dev/null`
    if [[ "${?}" == "0" ]]; then
      local b=`git hash-object -w $a`
      if [ -z "${b}" ]; then
        echo $white"Something wrong when created blob"$white
        failfn 1
      fi
      `git update-index --add --cacheinfo 100644 $b $a`
      echo $cyan"Blob$white $b as $a added in index"
    fi
  done
  okfn
}
