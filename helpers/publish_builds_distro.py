from distro import *
from glob import iglob, glob

release = scrapeVersion()
print "version = ", release

for i in glob("*.deb"):
  releaseFile(release,i,label="Development version (libraries and headers)")
