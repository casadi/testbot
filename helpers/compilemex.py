import subprocess

p= subprocess.Popen(["matlab","-nodisplay","-nosplash","-nodesktop","-r","""mex -v 'LDFLAGS="\$LDFLAGS -Wl,-rpath=/home/casadibot/slaves/linuxbot/linux-matlab/source/matlab_install/lib"' -I/home/casadibot/slaves/linuxbot/linux-matlab/source/matlab_install/include -L/home/casadibot/slaves/linuxbot/linux-matlab/source/matlab_install/lib /home/casadibot/slaves/linuxbot/linux-matlab/source/build/swig/casadi_coreMATLAB_wrap.cxx -lcasadi_core -ldl;quit"""],stdout = subprocess.PIPE, stderr = subprocess.PIPE)
stdout , stderr = p.communicate()

print stdout
print stderr
if p.returncode!=0:
  raise Exception("Compilation failed with return code %d" % p.returncode)

if "Error" in stderr:
  raise Exception("Compilation has errors.")
