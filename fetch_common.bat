python -c "from restricted import *; download('hsl_mingw%BITNESS%_trusty.zip')"
7z x -y "hsl_mingw%BITNESS%_trusty.zip" > nul
python -c "from restricted import *; download('slicot_mingw%BITNESS%_trusty.zip')"
7z x -y "slicot_mingw%BITNESS%_trusty.zip" > nul

python -c "from restricted import *; download('worhp_1.12-1_win%BITNESS%.zip')"
7z x -y "worhp_1.13-0_win%BITNESS%.zip" -oworhp > nul

python -c "from restricted import *; download('gurobi650_mingw%BITNESS%_trusty.zip')"
7z x -y "gurobi650_mingw%BITNESS%_trusty.zip" > nul

python -c "from restricted import *; download('snopt_mingw%BITNESS%_trusty.zip')"
7z x -y "snopt_mingw%BITNESS%_trusty.zip" > nul

choco install vcredist2015

python -c "from restricted import *; download('ifort%BITNESS%.msi')"
ifort%BITNESS%.msi /quiet /qn

python -c "from restricted import *; download('cplex_win1280.zip')"
7z x -y "cplex_win1280.zip" > nul

python -c "from restricted import *; download('knitro_mingw%BITNESS%_trusty.zip')"
7z x -y "knitro_mingw%BITNESS%_trusty.zip" > nul

set PATH=%PATH%;C:\projects\binaries\worhp\bin;\C:\projects\binaries\;C:\projects\binaries\bin%BITNESS%;C:\projects\binaries\bin;C:\Program Files (x86)\Common Files\Intel\Shared Libraries\redist\intel64_win\compiler;C:\Program Files (x86)\Common Files\Intel\Shared Libraries\redist\ia32_win\compiler;C:\projects\binaries\bin\x64_win%BITNESS%;
set WORHP_LICENSE_FILE=C:\projects\binaries\testbot\restricted\worhp\unlocked.lic
dir
dir worhp
set PATH=%PATH%;C:\projects\binaries\;C:\projects\binaries\knitro-10.3.2-z-WinMSVC10-%BITNESS%\lib
