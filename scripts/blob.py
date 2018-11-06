import sys, hashlib, zlib, os

if len(sys.argv) <= 1:
  print("the content is empty")
  exit(1)

content = sys.argv[1]
header = "blob {length}\0".format(length=len(content))
store = "{header}{content}".format(header=header,content=content)
sha1 = hashlib.sha1(store).hexdigest()

compressed = zlib.compress(store)

path = '.git/objects/' + sha1[:2]
os.mkdir(path)

filename = path + '/' + sha1[2:]
f = open(filename, 'w+')
f.write(compressed)
f.close()

print("sha1: {}".format(sha1))
