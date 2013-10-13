from distro import *
from glob import iglob, glo

import casadi
release = casadi.__version__

for i in glob("*.deb"):
  os.remove(i)
  releaseFile(release,i,label=""):
