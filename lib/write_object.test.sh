#!/usr/bin/env bats

@test "write-object should have the content valid with git blob" {
  content="Hello test"
  hash=$(plr hash-object $content)
  plr write-object $hash $content
  expected=$(git cat-file -p $hash)
  [ "$expected" == "$content" ]
}
