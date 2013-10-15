import subprocess
from glob import glob

p = subprocess.Popen(["pkg-config","--libs-only-L","ipopt"],stdout=subprocess.PIPE)
(out,err) = p.communicate()

d = out.split(" ")[0][2:]

f = file("extra_install.txt","w")
f.write(";".join(["%s;%s" % (i,"lib/ipopt") for i in glob(d+"/*.a")]))
f.close()

