[sqlite3 github 仓库链接](https://github.com/sqlite/sqlite)

See README.md for more information 

- 在Windows下编译
- 运行`VS2015 x64 x86 兼容工具命令提示符`，在`CD %SQLITE3PATH%`执行命令
```shell
nmake /f Makefile.msc
```
- 拷贝`shell.c` `sqlite3ext.h` `sqlite3.h` `sqlite3.c`  四个文件到src目录
- 下载安装[CMake](https://cmake.org/download/)
- `cmake`用`vs2022`版吧，`vs2015`一言难尽
- `git bash/cmd`进入`当前目录`
```shell
 # mingw GNU C/C++ 
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release

nmake install
```
- `msvc` for `virtual studio 2022`
```shell 
cmake  -G "Visual Studio 17 2022" -S . -B build
```

