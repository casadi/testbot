import subprocess

stdout , stderr = subprocess.Popen(["matlab","-nodisplay","-nosplash","-nodesktop","-r","""mex -v 'LDFLAGS="\$LDFLAGS -Wl,-rpath=/home/casadibot/slaves/linuxbot/linux-matlab/source/matlab_install/lib"' -I/home/casadibot/slaves/linuxbot/linux-matlab/source/matlab_install/include -L/home/casadibot/slaves/linuxbot/linux-matlab/source/matlab_install/lib /home/casadibot/slaves/linuxbot/linux-matlab/source/build/swig/casadi_coreMATLAB_wrap.cxx -lcasadi_core -ldl;quit"""],stdout = subprocess.PIPE, stderr = subprocess.PIPE).communicate()

