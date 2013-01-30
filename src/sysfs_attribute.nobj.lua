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
-- attribute access
--

-- typedefs
local typedefs = [[
typedef struct sysfs_attribute sysfs_attribute;
]]
c_source "typedefs" (typedefs)
-- pass extra C type info to FFI.
ffi_cdef (typedefs)

--
-- attribute
--
object "sysfs_attribute" {
	userdata_type = "generic",
	no_weak_ref = true,

	-- open
	constructor "open" {
		c_call "sysfs_attribute *" "sysfs_open_attribute" {
						"const char *", "path",
		}
	},
	-- close
	destructor "close" {
		c_method_call "void" "sysfs_close_attribute" {}
	},

	--
	-- lua binding specific methods for accessing 'struct sysfs_device' members
	--
	-- get name
	method "get_name" {
		c_source [[
  lua_pushstring(L, ${this}->name);
  return 1;
]]
	},
	-- get path
	method "get_path" {
		c_source [[
  lua_pushstring(L, ${this}->path);
  return 1;
]]
	},
	-- get value
	method "get_value" {
		c_source [[
  lua_pushstring(L, ${this}->value);
  return 1;
]]
	},
}
