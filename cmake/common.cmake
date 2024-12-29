# 开源库sdk根目录
# 获取指定相对路径的绝对路径
get_filename_component(third "third" ABSOLUTE BASE_DIR ${CURRENT_DIR})
message(STATUS "third= ${third}")
# 开源库头文件目录
set(third-include "${third}/include")
 
# vs编译器特化设置
if(MSVC)
    # 获取编译器信息
    # Win32-vc143|x64-vc143|...
    set(third-bin "${CMAKE_VS_PLATFORM_NAME}-vc${MSVC_TOOLSET_VERSION}/bin")
    set(third-lib "${CMAKE_VS_PLATFORM_NAME}-vc${MSVC_TOOLSET_VERSION}/lib")
    # debug工程生成的二进制文件名后增加“d”字符
    set(CMAKE_DEBUG_POSTFIX "d")

    # add_definitions(-D_SCL_SECURE_NO_WARNINGS)
    # CMAKE_VS_PLATFORM_NAME=x64 MSVC_TOOLSET_VERSION=143
    message(STATUS "vs version=${CMAKE_VS_PLATFORM_NAME}-vc${MSVC_TOOLSET_VERSION}")
endif()
 
#开源库sdk安装根目录
set(CMAKE_INSTALL_PREFIX "${third}")
message(STATUS "third sdk root dir=${CMAKE_INSTALL_PREFIX}")
 
#设置编译输出目录
# 设置静态库文件目录
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/../output/lib")
# 动态库文件目录
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/../output/lib")
# 可执行文件目录
# set(EXECUTABLE_OUTPUT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../output/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/../output/bin")