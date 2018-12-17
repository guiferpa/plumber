hash_object() {
  local content=$@
  local header="blob ${#content}\0"
  echo `printf "${header}${content}" | openssl sha1`
  okfn
}
