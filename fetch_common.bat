python -c "from restricted import *; download('hsl_mingw%BITNESS%_trusty.zip')"
7z x -y "hsl_mingw%BITNESS%_trusty.zip" > nul
python -c "from restricted import *; download('slicot_mingw%BITNESS%_trusty.zip')"
7z x -y "slicot_mingw%BITNESS%_trusty.zip" > nul

IF "%BITNESS%"=="32" (
    python -c "from restricted import *; download('libworhp_mingw-w64_i686_1.7-dd7abd3.7z')"
    7z x -y "libworhp_mingw-w64_i686_1.7-dd7abd3.7z" > nul
    set PATH=%PATH%;C:\projects\binaries\;C:\projects\binaries\libworhp_mingw-w64_i686_1.7-dd7abd3\bin
)

IF "%BITNESS%"=="64" (
    python -c "from restricted import *; download('libworhp_mingw-w64_x86_64_1.7-dd7abd3.7z')"
    7z x -y "libworhp_mingw-w64_x86_64_1.7-dd7abd3.7z" > nul
    set PATH=%PATH%;C:\projects\binaries\;C:\projects\binaries\libworhp_mingw-w64_x86_64_1.7-dd7abd3\bin
)


set WORHP_LICENSE_FILE=C:\projects\binaries\testbot\restricted\worhp\unlocked.lic
dir
set PATH=%PATH%;C:\projects\binaries\;
