#
# Lua bindings for libsysfs
#
cmake_minimum_required(VERSION 2.8)

project(lua-sysfs C)

set(BUILD_SHARED_LIBS TRUE)

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

set(INSTALL_CMOD share/lua/cmod CACHE PATH "Directory to install Lua binary modules (configure lua via LUA_CPATH)")

set(COMMON_CFLAGS "${CFLAGS}")
set(COMMON_LDFLAGS)
set(COMMON_LIBS)

## Lua 5.1.x
include(FindLua51)
if(NOT ${LUA51_FOUND})
    message(FATAL_ERROR "The FindLua51 module could not find lua :-(")
endif()
set(COMMON_LIBS "${COMMON_LIBS};${LUA_LIBRARIES}")

## LibSysfs
include(FindPkgConfig)
pkg_search_module(SYSFS REQUIRED libsysfs)
set(COMMON_CFLAGS "${COMMON_CFLAGS} ${SYSFS_CFLAGS}")
set(COMMON_LDFLAGS "${COMMON_LDFLAGS} ${SYSFS_LDFLAGS}")
set(COMMON_LIBS "${COMMON_LIBS};${SYSFS_LIBRARIES}")

## LuaNativeObjects
include(LuaNativeObjects)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}
                    ${CMAKE_CURRENT_BINARY_DIR}
                    ${LUA_INCLUDE_DIR})

## LuaSysfs
set(LUA_SYSFS_SRC
	sysfs.nobj.lua
)

if(${USE_PRE_GENERATED_BINDINGS})
	set(LUA_SYSFS_SRC src/pre_generated-sysfs.nobj.c)
else()
	# Generate Lua bindings.
	GenLuaNativeObjects(LUA_SYSFS_SRC)
endif()

add_library(lua-sysfs MODULE ${LUA_SYSFS_SRC})
target_link_libraries(lua-sysfs ${COMMON_LIBS})
set_target_properties(lua-sysfs PROPERTIES PREFIX "")
set_target_properties(lua-sysfs PROPERTIES COMPILE_FLAGS "${COMMON_CFLAGS}")
set_target_properties(lua-sysfs PROPERTIES OUTPUT_NAME sysfs)

install(TARGETS lua-sysfs
        DESTINATION "${INSTALL_CMOD}")

