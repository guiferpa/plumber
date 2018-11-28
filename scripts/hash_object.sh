hash_object() {
  local content=$@
  local header="blob ${#content}\0"
  local sha1=`printf "${header}${content}" | openssl sha1`

  echo "content: "$content
  echo "sha1: "$sha1

  local head="./.git/objects/${sha1:0:2}"
  local tail="${head}/${sha1:2}"

  mkdir -p $head
  printf "${header}${content}" | python -c "import zlib,sys; \
    print(zlib.compress(sys.stdin.read()))" >$tail
}
