write_object() {
  local hash=`plr hash-object $@`

  local content=$@
  local header="blob ${#content}\0"

  local head=".git/objects/${hash:0:2}"
  local tail="${head}/${hash:2}"

  mkdir -p $head
  printf "${header}${content}" | python -c "import zlib,sys; \
    print(zlib.compress(sys.stdin.read()))" >$tail

  echo $hash
  okfn
}
