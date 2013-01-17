#!/usr/bin/env lua

package	= 'lua-sysfs'
version	= 'scm-0'
source	= {
	url	= '__project_git_url__'
}
description	= {
	summary	= "LuaNativeObjects project template.",
	detailed	= '',
	homepage	= '__project_homepage__',
	license	= 'MIT',
	maintainer = "christian wiese",
}
dependencies = {
	'lua >= 5.1',
}
external_dependencies = {
	SYSFS = {
		header = "sysfs.h",
		library = "sysfs",
	}
}
build	= {
	type = "builtin",
	modules = {
		sysfs = {
			sources = { "src/pre_generated-sysfs.nobj.c" },
			libraries = { "sysfs" },
		}
	}
}
