#!/usr/bin/env bats

@test "hash-object should equals to output from git hash-object" {
  content="Hello test"
  expected="$(echo -n $content | git hash-object -t blob --stdin)"
  result="$(plr hash-object $content)"
  [ "$expected" == "$result" ]
}
