
import subprocess
import os
import tempfile
import shutil

def run(c):
  print c
  p = subprocess.Popen(c)
  p.wait()
  assert p.returncode==0

casadi_version = "v3.2.2"
if casadi_version.startswith("v"):
  casadi_dir = casadi_version[1:]
  target = casadi_version[1:]
else:
  casadi_dir = "commits/" + casadi_version
  target = casadi_version

target = target.replace("-",".")

for my_os,my_archive in [("linux","tar.gz"),("osx","tar.gz"),("windows","zip")]:
  for py_version in ["27","34","35","36"]:
    for bitness, suffix in [("64","-64bit"),("?","")]:
      lang_casadi = "py%s-np1.9.1" % py_version
      if my_os=="linux" or my_os=="osx":
        if py_version=="36":
	  lang_casadi = "py%s-np1.11" % py_version
        else:
	  lang_casadi = "py%s-np1.9" % py_version
      archive = my_os + "-" + "casadi-" + lang_casadi +"-" + casadi_version + suffix + "." + my_archive
      if not os.path.exists(archive):
        
        try:
          run(["wget", "http://sourceforge.net/projects/casadi/files/CasADi/" + casadi_dir + "/" + my_os + "/casadi-" + lang_casadi + "-" + casadi_version + suffix + "." + my_archive + "/download", "-O", archive])
        except:
          os.remove(archive)
          print "skipped"
          continue
      
      temp_dir = my_os + "-" + "casadi-" + lang_casadi +"-" + casadi_version + suffix
      if os.path.exists(temp_dir):
        shutil.rmtree(temp_dir)
      os.mkdir(temp_dir)

      if my_archive=="tar.gz":
        run(["tar", "-xvf", archive, "-C", temp_dir])
      else:
        run(["unzip", archive, "-d", temp_dir])

      try:
        os.remove(temp_dir + "/casadi/libcasadi_conic_cplex.so.3.3")
      except:
        pass
        
      run(["python","create_wheel.py",target,py_version,my_os,bitness, temp_dir])
