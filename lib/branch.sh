# cb - current branch
# bs - branches
# b - branch
# tmpl - template
# c - commit id
branch() {
  cb=`cbranchfn`
  bs=`ls -1 $heads | sort`
  if [ ! -z "${bs}" ]; then
    for b in $bs; do
      c=`cat $heads/$b`
      tmpl="$b"$white" -> $c"$white
      if [ "${b}" == "${cb}" ]; then
        echo $cyan"$tmpl"
      else
        echo $white"$tmpl"
      fi
    done | column
  fi
  okfn
}
