# b - blob
add() {
  for a in $@; do
    if [[ -f "${a}" ]]; then
      local b=`git hash-object -w $a`
      if [ -z "${b}" ]; then
        echo $white"Something wrong when created blob"$white
        failfn 1
      fi
      `git update-index --add --cacheinfo 100644 $b $a`
    fi
    echo $cyan"Blob$white $b as $a added in index"
  done

  okfn
}
