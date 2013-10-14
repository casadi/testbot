import subprocess
from glob import iglob, glob
from shutil import copy, copyfile
from os.path import join, split

import sys
import os
import re

import struct
bit_size = 8 * struct.calcsize("P") # 32 or 64


if len(sys.argv)>1:
    release = sys.argv[1]
else:
    import casadi
    release = casadi.__version__
    if '+' in release:
      try:
        release = casadi.CasadiMeta.getGitDescribe()
      except:
        pass

print "Releasing as version " , release

nonfree_server = os.environ["NONFREE_SERVER"] if "NONFREE_SERVER" in os.environ else "localhost"
    
def copy_files(src_glob, dst_folder):
    for fname in iglob(src_glob):
        try:
            copyfile(fname, join(dst_folder, split(fname)[1]))
        except IOError as e:
            print str(e)
            pass

#copy_files("..\\..\\libraries\\*.dll","python\\casadi")

# Clean dist dir
for i in glob("python/dist/*"):
    os.remove(i)
f = file('python/setup.py','w')
f.write("""
from distutils.core import setup, Extension
from glob import glob
from shutil import copyfile

setup(name="python-casadi",
    version="%s",
    description="CasADi is a symbolic framework for automatic differentation and numeric optimization",
    maintainer="Joris Gillis",
    author="Joel Andersson",
    url="casadi.org",
    packages=["casadi","casadi.tools","casadi.tools.graph"],
    package_data={"casadi": ["_casadi.so"]}
)

""" % release)
if '+' in release:
    releasedir = 'tested'
else:
    releasedir = release
f.close()
p = subprocess.Popen(["python","setup.py","bdist_rpm","--force-arch="+ ("x86_64" if bit_size==64 else "i686")],cwd="python")
p.wait()
p = subprocess.Popen(["fakeroot","alien",glob("python/dist/*"+("64" if bit_size==64 else "686")+".rpm")[-1].split("/")[-1]],cwd="python/dist")
p.wait()
if True:
        os.chdir("python/dist")
        subprocess.Popen(["ssh","nonfree@"+nonfree_server,"mkdir -p /home/nonfree/casadi/" + releasedir]).wait()
	links = []
        f = file('temp.batchftp','w')
	f.write("cd %s\n" % releasedir)
        for name in (["*.deb","*.tar.gz","*64.rpm"] if bit_size==64 else ["*.deb","*686.rpm"]):
	  target = glob(name)[0]
          f.write("put %s\n" % target)
	  if '+' in release:
            ln = re.sub("\+\d+\.[0-9a-f]+([_\-]\d+)?","+latest",target)
            ln2 = re.sub("casadi([_\-]).*latest","casadi\\1latest",ln)
            links.append("ln -f -s %s %s" % (target,ln))
            links.append("ln -f -s %s %s" % (target,ln2))
	f.close()
	p = subprocess.Popen(["sftp","-b","temp.batchftp","nonfree@"+nonfree_server+":/home/nonfree/casadi"])
	p.wait()
        subprocess.Popen(["ssh","nonfree@"+nonfree_server,"cd /home/nonfree/casadi/" + releasedir + " && " + " && ".join(links)]).wait()
