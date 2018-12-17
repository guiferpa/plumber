# https://github.com/git/git/blob/5d826e972970a784bd7a7bdf587512510097b8c7/Documentation/technical/index-format.txt
# https://mincong-h.github.io/2018/04/28/git-index
# https://msdn.microsoft.com/en-us/magazine/mt493250.aspx

  # _sweep_index is a function to read byte by byte the index file 
  # from git structure
  # 
  #   Usage:
  #     _sweep_index [0...] [0...] [0...] optional=[0...]
  # 
  #   Arguments:
  #     offset: The offset for reading
  #     limit:  The buffer limit that was read
  #     trans:  A parameter based in behavior between render char of parse to other base, 
  #     where case the input is 1 the function understand like true for render a character 
  #     instead of parse to some base. Default value is base 16
  #     wall: A parameter for condition compering current byte and the wall byte.
  #     When this condition is true the function stop immediately returnning current value
  #     as last byte that was read. Defualt value is ""
  #
_sweep_index() {
  if [ ! -f .git/index ]; then
    echo "Could not read the index file"
    failfn 1
  fi

  # _parse_to_base is a function to parse byte in base 16 to other base
  # 
  #   Usage:
  #     _parse_to_base [0...] [0...]
  # 
  #   Arguments:
  #     byte: The value of out base, case the value is less than 2 will be setted 2 as default
  #     base: The value of byte in base 16
  #
  _parse_to_base() {
    local byte=$1
    local base=$2
    if [[ ( "$base" == "16" ) || ( "$base" == "" ) ]]; then
      printf "$byte"
    else
      [ "$base" == "10" ] \
        && printf "$(echo "ibase=16; $byte" | bc)" \
        || printf "$(echo "ibase=16; obase=$base; $byte" | bc 2> /dev/null)"
    fi
  }

  local q="od -An -tx1"

  local offset=$1
  [[ ( $offset -gt 0 ) ]] && q="$q -j$offset"

  local limit=$2
  [[ ( $limit -gt 0 ) ]] && q="$q -N$limit"

  local trans=$3
  local wall=$4

  local buffer=$($q .git/index)
  local counter=0
  local bytes=""
  if [ "$trans" == "1" ]; then
    for byte in $buffer; do
      counter=$(($counter + 1))
      bytes="$bytes$(printf \\x$byte)"
      [ "$byte" == "$wall" ] && break
    done
    printf "$counter $bytes"
  else
    local base=$trans
    for byte in $buffer; do
      counter=$(($counter + 1))
      bytes="$bytes$byte"
      [ "$byte" == "$wall" ] && break
    done
    bytes=$(echo $bytes | awk '{print toupper($0)}')
    printf "$counter $(echo $(_parse_to_base $bytes $base) | awk '{print tolower($0)}')"
  fi
}

# - A 12-byte header consisting of
_read_index_header() {
  local offset=$1

  # 4-byte signature:
  #  The signature is { 'D', 'I', 'R', 'C' } (stands for "dircache")
  local sig=($(_sweep_index $offset 4 1))
  offset=$(( $offset + ${sig[0]} ))

  # 4-byte version number:
  #   The current supported versions are 2, 3 and 4.
  local v=($(_sweep_index $offset 4 10))
  offset=$(( $offset + ${v[0]} ))

  # 32-bit number of index entries. -> 32/8 = 4
  local e=($(_sweep_index $offset 4 10))
  offset=$(( $offset + ${e[0]} ))

  printf "$offset ${sig[1]} ${v[1]} ${e[1]}"
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
  local ctime=($(_sweep_index $offset 4 10))
  offset=$(( $offset + ${ctime[0]} ))

  # 32-bit ctime nanosecond fractions
  #  this is stat(2) data. -> 32/8 = 4
  local fctime=($(_sweep_index $offset 4 10))
  offset=$(( $offset + ${fctime[0]} ))

  # 32-bit mtime seconds, the last time a file's data changed
  #  this is stat(2) data. -> 32/8 = 4
  local mtime=($(_sweep_index $offset 4 10))
  offset=$(( $offset + ${mtime[0]} ))

  # 32-bit mtime nanosecond fractions
  #  this is stat(2) data. -> 32/8 = 4
  local fmtime=($(_sweep_index $offset 4 10))
  offset=$(( $offset + ${fmtime[0]} ))

  # 32-bit dev
  #   this is stat(2) data. -> 32/8 = 4
  local device=($(_sweep_index $offset 4 10))
  offset=$(( $offset + ${device[0]} ))

  # 32-bit ino
  #   this is stat(2) data. -> 32/8 = 4
  local ino=($(_sweep_index $offset 4 10))
  offset=$(( $offset + ${ino[0]} ))

  # 32-bit mode, split into (high to low bits). -> 32/8 = 4

  #  4-bit object type
  #    valid values in binary are 1000 (regular file), 1010 (symbolic link)
  #    and 1110 (gitlink)

  #  3-bit unused

  #  9-bit unix permission. Only 0755 and 0644 are valid for regular files.
  #  Symbolic links and gitlinks have value 0 in this field.
  local mode=($(_sweep_index $offset 4 8))
  offset=$(( $offset + ${mode[0]} ))

  # 32-bit uid
  #  this is stat(2) data. -> 32/8 = 4
  local uid=($(_sweep_index $offset 4 10))
  offset=$(( $offset + ${uid[0]} ))

  # 32-bit gid
  #  this is stat(2) data. -> 32/8 = 4
  local gid=($(_sweep_index $offset 4 10))
  offset=$(( $offset + ${gid[0]} ))

  # 32-bit file size
  #  This is the on-disk size from stat(2), truncated to 32-bit. -> 32/8 = 4
  local size=($(_sweep_index $offset 4 10))
  offset=$(( $offset + ${size[0]} ))

  # 160-bit SHA-1 for the represented object. -> 160/8 = 20
  local sha1=($(_sweep_index $offset 20))
  offset=$(( $offset + ${sha1[0]} ))

  # A 16-bit 'flags' field split into (high to low bits). 16/8 -> 2

  #  1-bit assume-valid flag

  #  1-bit extended flag (must be zero in version 2)

  #  2-bit stage (during merge)

  # 12-bit name length if the length is less than 0xFFF; otherwise 0xFFF
  #  is stored in this field.
  local flags=($(_sweep_index $offset 2 10))
  offset=$(( $offset + ${flags[0]} ))

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
  local name=($(_sweep_index $offset 0 1 00))
  offset=$(( $offset + ${name[0]} ))
  # 1-8 nul bytes as necessary to pad the entry to a multiple of eight bytes
  # while keeping the name NUL-terminated.
  local esize=$(($offset - $1)) # get only entry bytes size
  while [ ! $(echo "$esize % 8" | bc) -eq 0 ]; do # check if entry length is multiple of 8 bytes
    esize=$(( $esize + 1 ))
  done
  offset=$(( $esize + $1 )) # finally result, sum between initial offset and entry byte size

  local id=$(($2 + 1))

  printf "$offset $id ${ctime[1]}.${fctime[1]} ${mtime[1]}.${fmtime[1]} ${device[1]} ${ino[1]} ${mode[1]} ${uid[1]} ${gid[1]} ${size[1]} ${sha1[1]} ${flags[1]} ${name[1]}"
}

# == Extensions
_read_index_tree() {
  local offset=$1
  # === Cached tree

  # Cached tree extension contains pre-computed hashes for trees that can
  # be derived from the index. It helps speed up tree object generation
  # from index for a new commit.

  # When a path is updated in index, the path must be invalidated and
  # removed from tree cache.

  # The signature for this extension is { 'T', 'R', 'E', 'E' }.

  # A series of entries fill the entire extension; each of which
  # consists of:
  local sig=($(_sweep_index $offset 4 1))
  offset=$(( $offset + ${sig[0]} ))

  # - ASCII number representing the number of entries in the index covered by this tree entry.
  local size=($(_sweep_index $offset 4 10))
  offset=$(( $offset + ${size[0]} ))

  printf "$offset ${sig[1]} ${size[1]}"
}

_read_index_tree_data() {
  local offset=$1
  local size=$2

  # - NUL-terminated path component (relative to its parent directory);
  local path=($(_sweep_index $offset 0 1 00))
  [[ -z "${path[1]}" ]] && path=($(printf "${path[0]} <empty>"))
  offset=$(( $offset + ${path[0]} ))

  # - ASCII decimal number of entries in the index that is covered by the
  #  tree this entry represents (entry_count) A space (ASCII 32) -> 0x20;
  local entries=($(_sweep_index $offset 0 1 20))
  offset=$(( $offset + ${entries[0]} ))

  # - ASCII decimal number that represents the number of subtrees this
  #  tree has; A newline (ASCII 10); and
  local subtrees=($(_sweep_index $offset 0 1 0a))
  offset=$(( $offset + ${subtrees[0]} ))

  # - 160-bit object name for the object that would result from writing
  #   this span of index as a tree. -> 160 / 8 = 20
  local sha1=""
  if [ ! "${entries[1]}" == "-1" ]; then
    sha1=($(_sweep_index $offset 20))
    offset=$(( $offset + ${sha1[0]} ))
  fi

  printf "$offset ${path[1]} ${entries[1]} ${subtrees[1]} ${sha1[1]}"
}

# == Checksum
_read_index_checksum() {
  local offset=$1

  # - Finally, the last 20 bytes of the index contain an SHA-1 hash representing the index itself: 
  #  As expected, Git uses this SHA-1 value to validate the data integrity of the index.
  local sha1=($(_sweep_index $offset 0))
  offset=$(( $offset + ${sha1[0]} ))

  printf "$offset ${sha1[1]} ${sha1[0]}"
}

read_index() {
  # reading header
  local offset=0
  local header=($(_read_index_header $offset))
  local offset=${header[0]}
  cat << EOF
---
- offset: $offset
  type: "header"
  signature: "${header[1]}"
  version: ${header[2]}
  entries: ${header[3]}

EOF

  # reading entries
  for (( idx=0; idx<${header[3]}; idx++ )); do
    local entry=($(_read_index_entry $offset $idx))
    offset=${entry[0]}
  cat << EOF
- offset: $offset
  type: "entry"
  id: ${entry[1]}
  ctime: ${entry[2]}
  mtime: ${entry[3]}
  device: ${entry[4]}
  ino: ${entry[5]}
  mode: ${entry[6]}
  uid: ${entry[7]}
  gid: ${entry[8]}
  size: ${entry[9]}
  sha1: "${entry[10]}"
  flags: ${entry[11]}
  name: "${entry[12]}"

EOF
  done

  # reading extensions
  local ext=($(_sweep_index $offset 4 1))

  if [ "${ext[1]}" == "TREE" ]; then
    local tree=($(_read_index_tree $offset))
    offset=${tree[0]}
    cat << EOF
- offset: $offset
  type: "extension"
  signature: "${tree[1]}"
  size: ${tree[2]}
  data:
EOF

  # ==> reading data from tree extensions
  local tdsize=$((${offset} + ${tree[2]}))
  while [ $offset -lt $tdsize ]; do
    local tdata=($(_read_index_tree_data $offset))
    offset=${tdata[0]}
    cat << EOF
  - offset: $offset
    type: "data"
    path: "$([ "${tdata[1]}" == "<empty>" ] && echo "" || echo ${tdata[1]})"
    entries: ${tdata[2]}
    subtrees: ${tdata[3]}
    sha1: "${tdata[4]}"

EOF
  done

    ext=$(_sweep_index $offset 4)
  fi

  # reading checksum
  local checksum=($(_read_index_checksum $offset))
  offset=${checksum[0]}
  cat << EOF
- offset: $offset
  type: "checksum"
  sha1: "${checksum[1]}"
EOF
  okfn
} 
