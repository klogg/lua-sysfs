# lua-sysfs - Lua bindings for libsysfs

Christian Wiese chris@opensde.org

:exclamation: **WARNING**
The Lua bindings for `libsysfs` provided here are in a very early stage of development, thus do not use them in a production environment!

## Build Dependencies

Besides having a working compiler toolchain available you will need:

* cmake
* libsysfs

## Installing

### Install from git

Prepare a dedicated build directory
```
mkdir build
cd build
```

Generate Makefiles and related build infrastructure
```
cmake ../
```

Alternatively you can specify the path where to install the module
```
cmake ../ -DINSTALL_CMOD=/usr/local/lib/lua/5.1
```

Compile the module
```
make
```

Install the module
```
sudo make install
```

### Install using lua-rocks
```
curl -O "https://github.com/morfoh/lua-sysfs/raw/master/lua-sysfs-scm-0.rockspec"
luarocks install lua-sysfs-scm-0.rockspec
```

## Development

### Re-generating the bindings

By default CMake will use the pre-generated bindings that are include in the project.

To be able to re-generate the bindings, you will need to install *LuaNativeObjects* and set the CMake variable `USE_PRE_GENERATED_BINDINGS` to `FALSE`.
```
cmake ../ -DUSE_PRE_GENERATED_BINDINGS=FALSE
```

Mandantory for re-generating Lua bindings from `*.nobj.lua` files:

* [LuaNativeObjects](https://github.com/Neopallium/LuaNativeObjects), this is the bindings generator used to convert the `*.nobj.lua` files into a native Lua  module.

Optional for re-generating documentation

* [luadoc](https://github.com/keplerproject/luadoc)

To not re-generate documentation by luadocs when re-generating the bindings you have to to set the CMake variable `GENERATE_LUADOCS` to `FALSE`.
```
cmake ../ -DUSE_PRE_GENERATED_BINDINGS=FALSE -DGENERATE_LUADOCS=FALSE
```
