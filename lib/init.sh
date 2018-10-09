init() {
  [[ -z "${PWD}" ]] && PWD=`pwd`

  [[ -z "${1}" ]] && GIT_DIR="$PWD/$gitf" || GIT_DIR="$1/$gitf"

  if [ -d "$GIT_DIR" ]; then
    echo $wht"Already exists one repository on $GIT_DIR"$wht
    echo $rd"FAIL"$wht
    exit 1
  fi

  echo $wht"Creating empty Git repository in $GIT_DIR"$wht

  mkdir -p $GIT_DIR/objects \
    $GIT_DIR/info \
    $GIT_DIR/hooks \
    $GIT_DIR/refs \
    $GIT_DIR/refs/heads \
    $GIT_DIR/refs/tags

  touch $GIT_DIR/HEAD \
    $GIT_DIR/description \
    $GIT_DIR/config \
    $GIT_DIR/info/exclude

  cat <<EOF > $GIT_DIR/info/exclude
# git ls-files --others --exclude-from=.git/info/exclude
# Lines that start with '#' are comments.
# For a project mostly in C, the following would be a good set of
# exclude patterns (uncomment them if you want to use them):
# *.[oa]
# *~
EOF

  cat <<EOF > $GIT_DIR/config
[core]
  repositoryformatversion = 0
  filemode = true
  bare = false
  logallrefupdates = true
  ignorecase = true
  precomposeunicode = true
EOF

  echo "Unnamed repository; edit this file 'description' to name the repository." > $GIT_DIR/description

  echo "ref: refs/heads/master" > $GIT_DIR/HEAD

  echo $grn"OK"$wht
}