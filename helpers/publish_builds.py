import subprocess
from glob import iglob, glob
from shutil import copy, copyfile
from os.path import join, split
from distro import *

import shutil

#import sys
#sys.exit(0)

import sys
import os

import platform

a,b,_ = platform.dist()

platform_name = a+"-" + b.replace("/","-")

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
    
def copy_files(src_glob, dst_folder):
    for fname in iglob(src_glob):
        try:
            copyfile(fname, join(dst_folder, split(fname)[1]))
        except IOError as e:
            print str(e)
            pass

#copy_files("python_install/lib/*.so","python_install/casadi")

# Clean dist dir
for i in glob("python_install/dist/*"):
    os.remove(i)

for i in glob("python_install/lib/*.so"):
    if os.path.islink(i):
	ir = os.path.realpath(i)
	os.unlink(i)       
	shutil.copyfile(ir,i)

f = file('python_install/setup.py','w')
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
    package_data={"casadi": ["*.so"]},
    data_files=[('/usr/lib',glob("lib/*.so")),('/usr/lib',glob("lib/casadi/*.so"))]
)

""" % release)
if '+' in release:
    releasedir = 'tested'
else:
    releasedir = release
f.close()
p = subprocess.Popen(["python","setup.py","bdist_rpm","--force-arch=" + ("x86_64" if bit_size==64 else "i686")],cwd="python_install")
p.wait()
p = subprocess.Popen(["fakeroot","alien",glob("python_install/dist/*"+("64" if bit_size==64 else "686")+".rpm")[-1].split("/")[-1]],cwd="python_install/dist")
p.wait()
if True:
	f = file('temp.batchftp','w')
	f.write("mkdir %s\n" % releasedir)
	f.close()
	p = subprocess.Popen(["sftp","-b","temp.batchftp","casaditestbot,casadi@web.sourceforge.net:/home/pfs/project/c/ca/casadi/CasADi"])
	p.wait()
	
	f = file('temp.batchftp','w')
	f.write("mkdir %s\n" % (releasedir+"/"+platform_name))
	f.close()
	p = subprocess.Popen(["sftp","-b","temp.batchftp","casaditestbot,casadi@web.sourceforge.net:/home/pfs/project/c/ca/casadi/CasADi"])
	p.wait()

	f = file('temp.batchftp','w')
	f.write("cd %s\n" % (releasedir+"/"+platform_name))
	if platform_name!="Ubuntu-12.04":
	  releaseFile(casadi.__version__,glob("python_install/dist/*" + ("64" if bit_size==64 else "686")+".rpm")[0])
	f.write("put python_install/dist/*" + ("64" if bit_size==64 else "686")+".rpm\n")
	if platform_name!="Ubuntu-12.04":
	  releaseFile(casadi.__version__,glob("python_install/dist/*.deb")[0])
	f.write("put python_install/dist/*.deb\n")
	if bit_size==64:
	  f.write("put python_install/dist/*.tar.gz\n")
	  if platform_name!="Ubuntu-12.04":
	    releaseFile(casadi.__version__,glob("python_install/dist/*.tar.gz")[0])
	f.close()
	p = subprocess.Popen(["sftp","-b","temp.batchftp","casaditestbot,casadi@web.sourceforge.net:/home/pfs/project/c/ca/casadi/CasADi"])
	p.wait()
