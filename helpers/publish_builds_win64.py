import subprocess
from glob import iglob, glob
from shutil import copy, copyfile
from os.path import join, split

from distro import *

import sys
import os

if len(sys.argv)>1:
    release = sys.argv[1]
else:
    import casadi
    release = casadi.__version__
    if '+' in release:
      try:
         release = casadi.CasadiMeta.getGitDescription()
      except:
         pass

print "Releasing as version " , release
    
def copy_files(src_glob, dst_folder):
    for fname in iglob(src_glob):
        try:
            copyfile(fname, join(dst_folder, split(fname)[1]))
        except IOError as e:
            print str(e)
            pass

# Clean dist dir
for i in glob("python_install/dist/*"):
    os.remove(i)
f = file('setup.py','w')
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
    package_data={"casadi": ["_casadi.pyd","*.dll"]}
)

""" % release)
if '+' in release:
    releasedir = 'tested'
else:
    releasedir = release
f.close()
p = subprocess.Popen(["python","..\\setup.py","bdist_wininst","--target-version=2.7","--title=CasADi"],cwd="python_install")
p.wait()
p = subprocess.Popen(["python","..\\setup.py","bdist","--format=zip"],cwd="python_install")
p.wait()
f = file('temp.batchftp','w')
f.write("mkdir %s\n" % releasedir)
f.close()
p = subprocess.Popen(["sftp","-b","temp.batchftp","-i","../../../casadibot.key","-oUserKnownHostsFile=../../../known_hosts","casaditestbot,casadi@web.sourceforge.net:/home/pfs/project/c/ca/casadi/CasADi"])
p.wait()

f = file('temp.batchftp','w')
f.write("cd %s\n" % releasedir)
f.write("put python_install/dist/*\n")
f.close()
p = subprocess.Popen(["sftp","-b","temp.batchftp","-i","../../../casadibot.key","-oUserKnownHostsFile=../../../known_hosts","casaditestbot,casadi@web.sourceforge.net:/home/pfs/project/c/ca/casadi/CasADi"])
p.wait()

# Something is badly wrong here
#for i in glob("python/dist/*"):
#  releaseFile(casadi.__version__,i)
