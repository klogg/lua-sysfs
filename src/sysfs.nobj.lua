-- Copyright (c) 2013 by Christian Wiese <chris@opensde.org>
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

--
-- typedefs
--
local typedefs = [[
typedef struct dlist dlist;
]]
c_source "typedefs" (typedefs)
-- pass extra C type info to FFI.
ffi_cdef (typedefs)

--
-- Functions
--
c_function "get_mnt_path" {
	var_out { "char *", "mnt_path" },
	c_source[[
  char path[PATH_MAX];

  if (sysfs_get_mnt_path(path, PATH_MAX)) {
	lua_pushnil(L);
	return 1;
  } else {
	${mnt_path} = path;
  }
]],
}

c_source "src" {
[[
#define lua_sysfs_iterator(this, sysfs_get, lua_sysfs_iterator) \
	struct dlist *list = sysfs_get(this); \
	if (list) { \
		dlist_start(list); \
		lua_pushlightuserdata(L, list); \
		lua_pushcclosure(L, lua_sysfs_iterator, 1); \
		return 1; \
	}
]]
}

--
-- dlist
--
object "dlist" {
}
