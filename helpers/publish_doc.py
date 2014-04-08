import subprocess
from glob import iglob, glob
from shutil import copy, copyfile
from os.path import join, split

import sys
import os

import fileinput


if len(sys.argv)>1:
    release = sys.argv[1]
else:
    import casadi
    release = casadi.__version__
    official_release = True
    if '+' in release:
      official_release = False
      try:
        release = casadi.CasadiMeta.getGitDescribe()
      except:
        pass

print "Releasing as version " , release
print "official?", official_release
if '+' in release:
    releasedir = 'tested'
else:
    releasedir = release


def rsync(source,dest):
  p = subprocess.Popen(["rsync","-avP","--delete","-e","ssh"] + glob(source) + ["casaditestbot,casadi@web.sourceforge.net:/home/groups/c/ca/casadi/htdocs/" + dest],bufsize=0)
  p.wait()

if official_release:
  for line in fileinput.input("api/html/search/search.js", inplace = True):
    sys.stdout.write(line.replace("dbLocation", "\"../htdocs/v%s/api/html/doxysearch.db\"" % release))

  for line in fileinput.input("api/internal/search/search.js", inplace = True):
    sys.stdout.write(line.replace("dbLocation", "\"../htdocs/v%s/api/internal/doxysearch.db\"" % release))
    
  p = subprocess.Popen(["sftp","casaditestbot,casadi@web.sourceforge.net:/home/groups/c/ca/casadi/htdocs/"],stdin=subprocess.PIPE)
  p.communicate(input="mkdir v%s\nmkdir v%s/api\nmkdir v%s/tutorials\nmkdir v%s/users_guide\nmkdir v%s/cheatsheets\nmkdir v%s/users_guide/html" % (releasedir,releasedir,releasedir,releasedir,releasedir,releasedir))
  rsync("api/html","v%s/api/" % release)  
  rsync("api/internal","v%s/api/" % release)  
  file('tutorials/python/pdf/.htaccess','w').write("Options +Indexes")
  rsync("tutorials/python/pdf/","v%s/tutorials/" % release)  
  p = subprocess.Popen(["sftp","casaditestbot,casadi@web.sourceforge.net:/home/pfs/project/c/ca/casadi/CasADi"],stdin=subprocess.PIPE)
  p.communicate(input="cd %s\nput example_pack/example_pack.zip\n" % (releasedir))
  rsync("users_guide/*.pdf","v%s/users_guide/" % release)
  rsync("users_guide/casadi-users_guide/","v%s/users_guide/html" % release)
  rsync("cheatsheet/*.pdf","v%s/cheatsheets/" % release)
  
    
else:
  for line in fileinput.input("api/html/search/search.js", inplace = True):
    sys.stdout.write(line.replace("dbLocation", "\"../htdocs/api/html/doxysearch.db\""))

  for line in fileinput.input("api/internal/search/search.js", inplace = True):
    sys.stdout.write(line.replace("dbLocation", "\"../htdocs/api/internal/doxysearch.db\""))
    
  rsync("api/html","api/")
  rsync("api/internal","api/")
  file('tutorials/python/pdf/.htaccess','w').write("Options +Indexes")
  rsync("tutorials/python/pdf/","tutorials/")
  rsync("documents/*.pdf","documents/")
  rsync("cheatsheet/*.pdf","cheatsheets/")
  rsync("users_guide/*.pdf","users_guide/")
  rsync("users_guide/casadi-users_guide/","users_guide/html")

  p=subprocess.Popen(["sftp","casaditestbot,casadi@web.sourceforge.net:/home/pfs/project/c/ca/casadi/CasADi"],stdin=subprocess.PIPE)
  p.communicate(input="cd %s\nput example_pack/example_pack.zip\nrename example_pack.zip casadi-%s_example_pack.zip\n" % (releasedir,release))
  
