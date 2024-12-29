cmake_minimum_required(VERSION 3.10.1)
project(sqlite3)
# 公共配置
include(${CMAKE_SOURCE_DIR}/cmake/common.cmake)
set(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS ON)

# if(POLICY CMP0091)
#     # https://stackoverflow.com/a/56490614
#     cmake_policy(SET CMP0091 NEW)
# endif()

set(SQLITE3_VERSION "3.48.0")

set(output_dirname ${CMAKE_PROJECT_NAME}-${SQLITE3_VERSION})
message(STATUS "output_dirname = ${output_dirname}")

add_definitions(-DSQLITE_ENABLE_RTREE)
add_definitions(-DSQLITE_ENABLE_FTS4)
add_definitions(-DSQLITE_ENABLE_FTS5)
add_definitions(-DSQLITE_ENABLE_JSON1)
add_definitions(-DSQLITE_ENABLE_RBU)
add_definitions(-DSQLITE_ENABLE_STAT4)
# vs编译器特化设置
if(MSVC)
    # 增加sqlite3需要的宏定义
    add_definitions(-DSQLITE_THREADSAFE=1)
    add_definitions(-DSQLITE_THREAD_OVERRIDE_LOCK=1)
    add_definitions(-DSQLITE_TEMP_STORE=1)
    add_definitions(-DSQLITE_MAX_TRIGGER_DEPTH=100)
    add_definitions(-DSQLITE_ENABLE_FTS3=1)
    add_definitions(-DSQLITE_ENABLE_FTS5=1)
    add_definitions(-DSQLITE_ENABLE_RTREE=1)
    add_definitions(-DSQLITE_ENABLE_GEOPOLY=1)
    add_definitions(-DSQLITE_ENABLE_STMTVTAB=1)
    add_definitions(-DSQLITE_ENABLE_DBPAGE_VTAB=1)
    add_definitions(-DSQLITE_ENABLE_DBSTAT_VTAB=1)
    add_definitions(-DSQLITE_ENABLE_BYTECODE_VTAB=1)
    add_definitions(-DSQLITE_ENABLE_COLUMN_METADATA=1)
    add_definitions(-DSQLITE_ENABLE_MATH_FUNCTIONS)
    add_definitions(-DSQLITE_ENABLE_SESSION=1)
    add_definitions(-DSQLITE_ENABLE_PREUPDATE_HOOK=1)
    add_definitions(-DSQLITE_ENABLE_RBU=1)
endif()

include_directories(${CMAKE_SOURCE_DIR}/src)
set(SQLITE_HEADERS
    src/sqlite3.h
    src/sqlite3ext.h)
 
set(SQLITE_SOURCES 
    src/sqlite3.c)

#add_library(sqlite3 STATIC ${SQLITE_SOURCES} ${SQLITE_HEADERS})
add_executable(sqlite ${SQLITE_SOURCES} src/shell.c  ${SQLITE_HEADERS})

#set_target_properties(sqlite PROPERTIES OUTPUT_NAME sqlite3)


# Uncomment this for single-threaded variant (faster)
#add_definitions(-DSQLITE_THREADSAFE=0)

if(WIN32)
  add_custom_command(TARGET sqlite POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:sqlite> ${CMAKE_BINARY_DIR}/sqlite3.exe
    DEPENDS sqlite
  )
  install(FILES sqlite3.exe DESTINATION bin)
else()
  include(FindThreads)
  target_link_libraries(sqlite m ${CMAKE_THREAD_LIBS_INIT} ${CMAKE_DL_LIBS})
  install(TARGETS sqlite RUNTIME DESTINATION bin)
endif()
#拷贝头文件
# install(FILES src/sqlite3.h src/sqlite3ext.h DESTINATION include)
# 拷贝静态库或动态库
#install(TARGETS sqlite3 LIBRARY DESTINATION lib ARCHIVE DESTINATION lib)

# 动态库工程
add_library(sqlite3.dynamic SHARED ${SQLITE_HEADERS} ${SQLITE_SOURCES} src/sqlite3.def)
 
# 静态库工程
add_library(sqlite3.static STATIC ${SQLITE_HEADERS} ${SQLITE_SOURCES})

# vs编译器特化设置
if(MSVC)
    # mt动态库工程
    add_library(sqlite3.dynamic.mt SHARED ${SQLITE_HEADERS} ${SQLITE_SOURCES} src/sqlite3.def)
    set_property(TARGET sqlite3.dynamic.mt PROPERTY
        MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
 
    # mt静态库工程
    add_library(sqlite3.static.mt STATIC ${SQLITE_HEADERS} ${SQLITE_SOURCES})
    set_property(TARGET sqlite3.static.mt PROPERTY
        MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
 
    # 查找pdb文件
    file(GLOB_RECURSE SQLITE_DEBUG_SYMBOLS ${PROJECT_BINARY_DIR}/output/
        FILES_MATCHING PATTERN "sqlite*.pdb")
endif()


# 安装编译输出的二进制文件
if(NOT SKIP_INSTALL_LIBRARIES AND NOT SKIP_INSTALL_ALL)
    install(TARGETS sqlite3.dynamic sqlite3.static sqlite3.dynamic.mt sqlite3.static.mt
        RUNTIME DESTINATION ${third-bin}/${output_dirname}
        LIBRARY DESTINATION ${third-lib}/${output_dirname}
        ARCHIVE DESTINATION ${third-lib}/${output_dirname})
endif()
 
# 安装外部开发时需要的头文件
if(NOT SKIP_INSTALL_HEADERS AND NOT SKIP_INSTALL_ALL)
    install(FILES ${SQLITE_HEADERS} DESTINATION ${third-include}/${output_dirname})
endif()
 
# 安装pdb文件
if(NOT SKIP_INSTALL_HEADERS AND NOT SKIP_INSTALL_ALL)
    install(FILES ${SQLITE_DEBUG_SYMBOLS} DESTINATION ${third-bin}/${output_dirname})
endif()