write_object() {
  local f=${@:0:1}
  local c=${@:2}

  local hr="blob ${#c}\0"

  mkdir -p $(dirname $f)
  printf "${hr}${c}" | python -c "import zlib,sys; \
    print(zlib.compress(sys.stdin.read()))" >$f

  echo $f
  okfn
}
