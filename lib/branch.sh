branch() {
  cb=`cat .git/HEAD | awk '{print substr($2, 12, length($2))}'`
  bs=`ls -1 $gitf/refs/heads | sort`
  if [ ! -z "${bs}" ]; then
    for b in $bs; do
      h=`cat $gitf/refs/heads/$b`
      if [ "${b}" == "${cb}" ]; then
        echo $cyan"$b"$white" -> $h"$white
      else
        echo $white"$b"$white" -> $h"$white
      fi
    done | column
  fi
  okfn
}
