# fmt - format
branch() {
  local fmt="%(if)%(HEAD)%(then)$cyan* $white%(else)%(end)%(refname:short) -> %(objectname)"
  git for-each-ref --format="$fmt" refs/heads/ | column
  okfn
}
