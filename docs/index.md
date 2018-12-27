# Index
The index is a binary file that exist for make it easier all work from Git caching the current stage area state.

The index file contain 4 sections that are: **header**, **entry**, **extension** and **checksum**.

## Header
It's the a metadata section about index file with the attributes: **signature**, **version** and **amount of entries**.

### Signature
Nowaday signature must is equal `DIRC`, that means _dircache_, this will be take 4 bytes being each letter 1 byte.

### Version
The version of index file and the versions supported are 2, 3 and 4 and is represented for 4 bytes.

### Entries
The entries amount is represented for 4 bytes with reference in ASCII Table.


#### Index file on header context
```
[44 49 52 43] [00 00 00 02] [00 00 00 14] ...
```

| Bytes       | Mover        | Result   |
| ----------- | ------------ | -------- |
| 44 49 52 43 | ASCII Table  | D I R C  |
| 00 00 00 02 | Base 10      | 2        |
| 00 00 00 14 | Base 10      | 20       |
