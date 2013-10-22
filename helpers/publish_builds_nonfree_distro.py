from distro import *
import subprocess
from glob import iglob, glob

release = scrapeVersion()

if '+' in release:
    releasedir = 'tested'
else:
    releasedir = release
   
    
nonfree_server = os.environ["NONFREE_SERVER"] if "NONFREE_SERVER" in os.environ else "localhost"

f = file('temp.batchftp','w')
f.write("cd %s\n" % releasedir)

for i in glob("*.deb"):
  f.write("put %s\n" % i)

f.close()
p = subprocess.Popen(["sftp","-b","temp.batchftp","nonfree@"+nonfree_server+":/home/nonfree/casadi"])
p.wait()
