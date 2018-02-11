python -c "from restricted import *; download('hsl_mingw%BITNESS%_trusty.zip')"
7z x -y "hsl_mingw%BITNESS%_trusty.zip" > nul
python -c "from restricted import *; download('slicot_mingw%BITNESS%_trusty.zip')"
7z x -y "slicot_mingw%BITNESS%_trusty.zip" > nul

python -c "from restricted import *; download('libworhp_vs2013_1.10-2.7z')"
7z x -y "libworhp_vs2013_1.10-2.7z" > nul

python -c "from restricted import *; download('gurobi650_mingw%BITNESS%_trusty.zip')"
7z x -y "gurobi650_mingw64_trusty.zip" > nul

set PATH=%PATH%;C:\projects\binaries\;C:\projects\binaries\bin%BITNESS%;C:\projects\binaries\bin
set WORHP_LICENSE_FILE=C:\projects\binaries\testbot\restricted\worhp\unlocked.lic
dir
set PATH=%PATH%;C:\projects\binaries\;
