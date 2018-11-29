# b - blob
add() {
  for a in $@; do
    local p=`cat $a 2> /dev/null`
    if [[ "${?}" == "0" ]]; then
      local b=`plr write-object $p`
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
