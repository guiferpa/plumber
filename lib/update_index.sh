
# https://unix.stackexchange.com/questions/10801/how-to-use-bash-script-to-read-binary-file-content
# build binary data from state of stage in index file

# transformed state after the above steps: 

# ```sh
# $ echo -n "Hello world" >hello.txt
# $ git add hello.txt
# ```

  # printf \\x44 >binfile
  # ( printf \\x49
  #   printf \\x52
  #   printf \\x43
  #   printf \\x00
  #   printf \\x00
  #   printf \\x00
  #   printf \\x02
  #   printf \\x00
  #   printf \\x00
  #   printf \\x00
  #   printf \\x01
  #   printf \\x5C
  #   printf \\x07
  #   printf \\xF4
  #   printf \\xE6

  #   printf \\x1B
  #   printf \\x96
  #   printf \\xD6
  #   printf \\x1C
  #   printf \\x5C
  #   printf \\x07
  #   printf \\xF4
  #   printf \\xE6
  #   printf \\x1B
  #   printf \\x96
  #   printf \\xD6
  #   printf \\x1C
  #   printf \\x01
  #   printf \\x00
  #   printf \\x00
  #   printf \\x04

  #   printf \\x00
  #   printf \\x43
  #   printf \\x0B
  #   printf \\x9A
  #   printf \\x00
  #   printf \\x00
  #   printf \\x81
  #   printf \\xA4
  #   printf \\x60
  #   printf \\x6A
  #   printf \\x83
  #   printf \\x3C
  #   printf \\x32
  #   printf \\xB5
  #   printf \\xF2
  #   printf \\xBB

  #   printf \\x00
  #   printf \\x00
  #   printf \\x00
  #   printf \\x0B
  #   printf \\x70
  #   printf \\xC3
  #   printf \\x79
  #   printf \\xB6
  #   printf \\x3F
  #   printf \\xFA
  #   printf \\x07
  #   printf \\x95
  #   printf \\xFD
  #   printf \\xBF
  #   printf \\xBC
  #   printf \\x12

  #   printf \\x8E
  #   printf \\x5A
  #   printf \\x28
  #   printf \\x18
  #   printf \\x39
  #   printf \\x7B
  #   printf \\x7E
  #   printf \\xF8
  #   printf \\x00
  #   printf \\x09
  #   printf \\x68
  #   printf \\x65
  #   printf \\x6C
  #   printf \\x6C
  #   printf \\x6F
  #   printf \\x2E

  #   printf \\x74
  #   printf \\x78
  #   printf \\x74
  #   printf \\x00
  #   printf \\x82
  #   printf \\xF0
  #   printf \\x5A
  #   printf \\x60
  #   printf \\x6F
  #   printf \\x3C
  #   printf \\x24
  #   printf \\xD5
  #   printf \\xD4
  #   printf \\x08
  #   printf \\xE3
  #   printf \\xD9

  #   printf \\xB9
  #   printf \\x49
  #   printf \\xCB
  #   printf \\x64
  #   printf \\x37
  #   printf \\xE1
  #   printf \\x32
  #   printf \\x3B) >>binfile

# 00000000: 4449 5243 0000 0002 0000 0001 5c07 f4e6  DIRC........\...
# 00000010: 1b96 d61c 5c07 f4e6 1b96 d61c 0100 0004  ....\...........
# 00000020: 0043 0b9a 0000 81a4 606a 833c 32b5 f2bb  .C......`j.<2...
# 00000030: 0000 000b 70c3 79b6 3ffa 0795 fdbf bc12  ....p.y.?.......
# 00000040: 8e5a 2818 397b 7ef8 0009 6865 6c6c 6f2e  .Z(.9{~...hello.
# 00000050: 7478 7400 82f0 5a60 6f3c 24d5 d408 e3d9  txt...Z`o<$.....
# 00000060: b949 cb64 37e1 323b                      .I.d7.2;

# ost - offset
# len - length
# f - file
# bf - binary file
update_index() {
  okfn
}


