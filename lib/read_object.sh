read_object() {
  local h=$1

  f=".git/objects/${h:0:2}/${h:2}"
  printf "$f" | python -c "import zlib,sys; \
    print(zlib.decompress(open(sys.stdin.read(), 'rb').read()))"

  okfn
}
