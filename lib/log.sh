# co - commit object
# cc - current commit id
revision_read_log() {
  local fmt="
"$cyan"Tree:"$white"   %T
"$cyan"Parent:"$white" %P
"$cyan"Author:"$white" %an <%ae> %ad

  %s

  %b
"
  if [ "${2}" == "--all" ]; then
    git rev-list --reverse --format=format:"$fmt" --exclude=commit HEAD
  else
    local max="5"
    [ ! -z ${2} ] && max=$2
    git rev-list --reverse --format=format:"$fmt" --max-count=$max HEAD
  fi
}

log() {
  revision_read_log HEAD $1
  okfn
}
