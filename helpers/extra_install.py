import subprocess
from glob import glob
import os

p = subprocess.Popen(["pkg-config","--libs-only-L","ipopt"],stdout=subprocess.PIPE)
(out,err) = p.communicate()

d = out.split(" ")[0][2:]

f = file("extra_install.cmake","w")
#for i in glob(d+"/*.a"):
#  ri = "libcasadi_"+os.path.basename(i)[3:]
#  f.write("install(FILES %s DESTINATION lib RENAME %s)\n" % (i,ri))
  
#f.write("install(FILES ${PROJECT_BINARY_DIR}/swig/CasadiTree.hs ${PROJECT_BINARY_DIR}/swig/CasadiClasses.hs ${PROJECT_BINARY_DIR}/swig/swiginclude.hpp ${PROJECT_BINARY_DIR}/swig/linklist.txt DESTINATION share/casadi)\n")

#f.write("""install(DIRECTORY ${PROJECT_SOURCE_DIR}/swig DESTINATION share/casadi FILES_MATCHING PATTERN "*.i" PATTERN "*doc.i" EXCLUDE)\n""")
