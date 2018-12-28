# Index
The index is a binary file that exist for make it easier all work from Git caching the current stage area state.

The index file contain 4 sections that are: [header](#header), [entry](#entry), [extension](#extension) and [checksum](#checksum).

> :triangular_flag_on_post: All the examples below are based on a file called `hello.txt` with `Hello world` as content

## Header
It's the a metadata section about index file with the attributes: [signature](#signature), [version](version) and [entries](#entries).

### Signature
Nowaday signature must is equal `DIRC`, that means _dircache_, this will be take 4 bytes being each letter 1 byte.

### Version
The version of index file and the versions supported are 2, 3 and 4 and is represented for 4 bytes.

### Entries
The entries amount is represented for 4 bytes with reference in ASCII Table.


#### Index file on header context
| Attribute | Bytes       | Mover             | Result   |
| --------- | ----------- | ----------------- | -------- |
| signature | 44 49 52 43 | Base 10 _(ASCII)_ | D I R C  |
| version   | 00 00 00 02 | Base 10           | 2        |
| entries   | 00 00 00 01 | Base 10           | 1        |

## Entry

#### Index file on entry context
| Attribute      | Bytes                                                       | Mover             | Result      |
| -------------- | ----------------------------------------------------------- | ----------------- | ----------- |
| ctime seconds  | 5c 26 3b 40                                                 | Base 10           | 1546009408  |
| ctime nanosecs | 01 c8 93 26                                                 | Base 10           | 29922086    |
| mtime seconds  | 5c 26 3b 40                                                 | Base 10           | 1546009408  |
| mtime nanosecs | 01 c8 93 26                                                 | Base 10           | 29922086    |
| dev            | 01 00 00 04                                                 | Base 10           | 16777220    |
| ino            | 00 4d b5 d2                                                 | Base 10           | 5092818     |
| mode           | 00 00 81 a4                                                 | Base 8            | 100644      |
| uid            | 60 6a 83 3c                                                 | Base 10           | 1617593148  |
| gid            | 32 b5 f2 bb                                                 | Base 10           | 850784955   |
| size           | 00 00 00 0c                                                 | Base 10           | 12          |
| sha1           | 80 29 92 c4 22 0d e1 9a 90 76 7f 30 00 a7 9a 31 b9 8d 0d f7 | Base 16           | 802992c4... |
| flags          | 00 09                                                       | Base 10           | 9           |
| name           | 68 65 6c 6c 6f 2e 74 78 74 00                               | Base 16 _(ASCII)_ | hello.txt   |

## Extension

## Checksum

#### Index file on checksum context
| Attribute  | Bytes                                                        | Mover             | Result       |
| ---------- | ------------------------------------------------------------ | ----------------- | ------------ |
| sha1       | 29 ef c6 bb 44 99 f5 00 3c b0 80 f8 52 ea 5e 31 2a 1e e6 f6  | Base 16           | 29efc6bb...  |
