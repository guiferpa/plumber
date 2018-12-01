#!/usr/bin/env bats

@test "write-object should have result equals the filename wrote" {
  filename="$PWD/tmp/objects/te/sting"
  content="Hello test"
  result=$(plr write-object $filename $content)
  [ "$result" == "$filename" ]
}

@test "write-object should write the object on filename input" {
  filename="$PWD/tmp/objects/te/sting"
  content="Hello test"
  result=$(plr write-object $filename $content)
  run cat $result
  [ "$status" -eq 0 ]
}

@test "write-object should have the content valid with git blob" {
  content="Hello test"
  hash=$(plr hash-object $content)
  filename="$PWD/.git/objects/${hash:0:2}/${hash:2}"
  plr write-object $filename $content
  expected=$(git cat-file -p $hash)
  [ "$expected" == "$content" ]
}
