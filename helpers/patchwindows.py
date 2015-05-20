import fileinput
for l in fileinput.input('c:/mingw/include/io.h',inplace=1):
  print l.rstrip().replace(' off64_t',' _off64_t')
