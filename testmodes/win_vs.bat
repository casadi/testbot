cd ..
cmake "-GVisual Studio 12 Win64" -H. -B_builds
cmake --build _builds --config "Debug"
