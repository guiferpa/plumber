# cb - current branch
# bs - branches
# b - branch
# tmpl - template
# c - commit id
branch() {
  local cb=`cbranchfn`
  local bs=`ls -1 $heads | sort`
  if [ ! -z "${bs}" ]; then
    for b in $bs; do
      local c=`cat $heads/$b`
      local tmpl="$b"$white" -> $c"$white
      if [ "${b}" == "${cb}" ]; then
        echo $cyan"$tmpl"
      else
        echo $white"$tmpl"
      fi
    done | column
  fi
  okfn
}
