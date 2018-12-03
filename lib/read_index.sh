# https://github.com/git/git/blob/5d826e972970a784bd7a7bdf587512510097b8c7/Documentation/technical/index-format.txt
# https://mincong-h.github.io/2018/04/28/git-index

_read_index_b16() {
  local offset=$1
  local limit=$2
  local bytes=""
  if [ "$limit" == "" ]; then
    bytes=$(od -An -tx1 -j$offset .git/index)
  else
    bytes=$(od -An -tx1 -j$offset -N$limit .git/index)
  fi
  for byte in $bytes; do
    printf $byte
  done
}

_read_index_b10() {
  local r=$(echo $(_read_index_b16 $1 $2) | awk '{print toupper($0)}')
  printf $(echo "ibase=16; $r" | bc)
}

_read_index_b() {
  local r=$(echo $(_read_index_b16 $2 $3) | awk '{print toupper($0)}')
  printf $(echo "ibase=16; obase=$1; $r" | bc)
}

_read_index_char() {
  local bytes=$(_read_index_b16 $1 $2)
  local w=""
  for i in $(seq 0 2 $((${#bytes} - 2))); do
    if [ "${bytes:$i:2}" == "00" ]; then
      local length=$(printf $w | wc -c)
      printf "$(($length + 1)) $w"
      exit 0
    fi
    w="$w$(printf \\x${bytes:$i:2})"
  done
  local length=$(printf $w | wc -c)
  printf "$length $w"
}

# - A 12-byte header consisting of
_read_index_header() {
  local offset=$1

  # 4-byte signature:
  #  The signature is { 'D', 'I', 'R', 'C' } (stands for "dircache")
  local sig=($(_read_index_char $offset 4))
  offset=$(( $offset + ${sig[0]} ))

  # 4-byte version number:
  #   The current supported versions are 2, 3 and 4.
  local v=$(_read_index_b10 $offset 4)
  offset=$(( $offset + 4 ))

  # 32-bit number of index entries. -> 32/8 = 4
  local e=$(_read_index_b10 $offset 4)
  offset=$(( $offset + 4 ))

  printf "$offset ${sig[1]} $v $e"
}

# == Index entry

#   Index entries are sorted in ascending order on the name field,
#   interpreted as a string of unsigned bytes (i.e. memcmp() order, no
#   localization, no special casing of directory separator '/'). Entries
#   with the same name are sorted by their stage field.
_read_index_entry() {
  local offset=$1

  # 32-bit ctime seconds, the last time a file's metadata changed
  #  this is stat(2) data. -> 32/8 = 4
  local ctime=$(_read_index_b10 $offset 4)
  offset=$(( $offset + 4 ))

  # 32-bit ctime nanosecond fractions
  #  this is stat(2) data. -> 32/8 = 4
  local fctime=$(_read_index_b10 $offset 4)
  offset=$(( $offset + 4 ))

  # 32-bit mtime seconds, the last time a file's data changed
  #  this is stat(2) data. -> 32/8 = 4
  local mtime=$(_read_index_b10 $offset 4)
  offset=$(( $offset + 4 ))

  # 32-bit mtime nanosecond fractions
  #  this is stat(2) data. -> 32/8 = 4
  local fmtime=$(_read_index_b10 $offset 4)
  offset=$(( $offset + 4 ))

  # 32-bit dev
  #   this is stat(2) data. -> 32/8 = 4
  local device=$(_read_index_b10 $offset 4)
  offset=$(( $offset + 4 ))

  # 32-bit ino
  #   this is stat(2) data. -> 32/8 = 4
  local ino=$(_read_index_b10 $offset 4)
  offset=$(( $offset + 4 ))

  # 32-bit mode, split into (high to low bits). -> 32/8 = 4

  #  4-bit object type
  #    valid values in binary are 1000 (regular file), 1010 (symbolic link)
  #    and 1110 (gitlink)

  #  3-bit unused

  #  9-bit unix permission. Only 0755 and 0644 are valid for regular files.
  #  Symbolic links and gitlinks have value 0 in this field.
  local mode=$(_read_index_b 8 $offset 4)
  offset=$(( $offset + 4 ))

  # 32-bit uid
  #  this is stat(2) data. -> 32/8 = 4
  local uid=$(_read_index_b10 $offset 4)
  offset=$(( $offset + 4 ))

  # 32-bit gid
  #  this is stat(2) data. -> 32/8 = 4
  local gid=$(_read_index_b10 $offset 4)
  offset=$(( $offset + 4 ))

  # 32-bit file size
  #  This is the on-disk size from stat(2), truncated to 32-bit. -> 32/8 = 4
  local size=$(_read_index_b10 $offset 4)
  offset=$(( $offset + 4 ))

  # 160-bit SHA-1 for the represented object. -> 160/8 = 20
  local sha1=$(_read_index_b16 $offset 20)
  offset=$(( $offset + 20 ))

  # A 16-bit 'flags' field split into (high to low bits). 16/8 -> 2

  #  1-bit assume-valid flag

  #  1-bit extended flag (must be zero in version 2)

  #  2-bit stage (during merge)

  # 12-bit name length if the length is less than 0xFFF; otherwise 0xFFF
  #  is stored in this field.
  local flags=$(_read_index_b10 $offset 2)
  offset=$(( $offset + 2 ))

  # Entry path name (variable length) relative to top level directory
  #  (without leading slash). '/' is used as path separator. The special
  #  path components ".", ".." and ".git" (without quotes) are disallowed.
  #  Trailing slash is also disallowed.

  #  The exact encoding is undefined, but the '.' and '/' characters
  #  are encoded in 7-bit ASCII and the encoding cannot contain a NUL
  #  byte (iow, this is a UNIX pathname).

  # (Version 4) In version 4, the entry path name is prefix-compressed
  #  relative to the path name for the previous entry (the very first
  #  entry is encoded as if the path name for the previous entry is an
  #  empty string).  At the beginning of an entry, an integer N in the
  #  variable width encoding (the same encoding as the offset is encoded
  #  for OFS_DELTA pack entries; see pack-format.txt) is stored, followed
  #  by a NUL-terminated string S.  Removing N bytes from the end of the
  #  path name for the previous entry, and replacing it with the string S
  #  yields the path name for this entry.
  local name=($(_read_index_char $offset))
  offset=$(( $offset + ${name[0]} ))
  # 1-8 nul bytes as necessary to pad the entry to a multiple of eight bytes
  # while keeping the name NUL-terminated.
  local esize=$(($offset - $1)) # get only entry bytes size
  while [ ! $(echo "$esize % 8" | bc) -eq 0 ]; do # check if entry length is multiple of 8 bytes
    esize=$(( $esize + 1 ))
  done
  offset=$(( $esize + $1 )) # finally result, sum between initial offset and entry byte size

  printf "$offset $(($2 + 1)) $ctime.$fctime $mtime.$fmtime $device $ino $mode $uid $gid $size $sha1 $flags ${name[1]}"
}

read_index() {
  if [ ! -f .git/index ]; then
    echo "Could not read the index file"
    failfn 1
  fi
  local header=($(_read_index_header 0))
  local offset=${header[0]}
  echo "${header[@]}"
  for (( idx=0; idx<${header[3]}; idx++ )); do
    local entry=($(_read_index_entry $offset $idx))
    offset=${entry[0]}
    echo ${entry[@]}
  done
  okfn
} 
