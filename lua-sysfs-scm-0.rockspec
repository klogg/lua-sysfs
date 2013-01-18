#!/usr/bin/env lua

package	= 'lua-sysfs'
version	= 'scm-0'
source	= {
	url	= 'https://github.com/morfoh/lua-sysfs'
}
description	= {
	summary	= "Lua bindings for libsysfs.",
	detailed	= '',
	homepage	= 'https://github.com/morfoh/lua-sysfs',
	license	= 'MIT',
	maintainer = "Christian Wiese",
}
dependencies = {
	'lua >= 5.1',
}
external_dependencies = {
	SYSFS = {
		header = "sysfs/libsysfs.h",
		library = "sysfs",
	}
}
build	= {
	type = "builtin",
	modules = {
		sysfs = {
			sources = { "src/sysfs.nobj.pre_generated.c" },
			libraries = { "sysfs" },
		}
	}
}
