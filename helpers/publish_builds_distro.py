from distro import *
from glob import iglob, glob

import sys
sys.exit(0)

release = scrapeVersion()
print "version = ", release

for i in glob("*.deb"):
  releaseFile(release,i,label="Development version (libraries and headers)")
  
purgeLatest()
