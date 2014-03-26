import subprocess
from glob import iglob, glob
from shutil import copy, copyfile
from os.path import join, split

import sys
import os

def rsync(source,dest):
  p = subprocess.Popen(["rsync","-avP","--delete","-e","ssh"] + glob(source) + ["casaditestbot,casadi@web.sourceforge.net:/home/groups/c/ca/casadi/htdocs/" + dest],bufsize=0)
  p.wait()

rsync(".","coverage/")

