#!/bin/sh

white=$'\e[0m'
green=$'\e[1;32m'
red=$'\e[1;31m'

repo="plumber"
dst=".$repo"

pushd $HOME
git clone "git@github.com:guiferpa/$repo.git" $dst
pushd $dst
make clean && make

`plr -v >/dev/null 2>/dev/null`
[ "${?}" == "0" ] && echo $green"[OK] "$white"$repo installed successfully, try run 'plr --version'" \
  || echo $red"[ERR] "$white"$repo install failure"
