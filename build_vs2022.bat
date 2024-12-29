@echo on
rd /S /Q "%~dp0build"
cmake  -G "Visual Studio 17 2022" -S . -B build

cmake --build %~dp0build --config Release
