import subprocess
from glob import glob

p = subprocess.Popen(["pkg-config","--libs-only-L","ipopt"],stdout=subprocess.PIPE)
(out,err) = p.communicate()

d = out.split(" ")[0][2:]

f = file("extra_install.cmake","w")
for i in glob(d+"/*.a"):
  f.write("install(FILES %s DESTINATION ipopt/dir)\n" % i)
