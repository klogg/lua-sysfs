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
-- sysfs module
--

-- typedefs
local typedefs = [[
typedef struct sysfs_module sysfs_module;
]]
c_source "typedefs" (typedefs)
-- pass extra C type info to FFI.
ffi_cdef (typedefs)


-- sysfs module object
object "sysfs_module" {
	userdata_type = "generic",
	no_weak_ref = true,

	-- open
	constructor "open" {
		c_call "sysfs_module *" "sysfs_open_module" {
						"const char *", "name",
		}
	},
	-- close
	destructor "close" {
		c_method_call "void" "sysfs_close_module" {}
	},
	-- open path
	constructor "open_path" {
		c_call "sysfs_module *" "sysfs_open_module_path" {
						"const char *", "path",
		}
	},
	-- get attribute
	method "get_attr" {
		c_method_call "sysfs_attribute *" "sysfs_get_module_attr" {
						"const char *", "name"
		}
	},
	-- get parameter
	method "get_parm" {
		c_method_call "sysfs_attribute *" "sysfs_get_module_parm" {
						"const char *", "parameter"
		}
	},
	-- get section
	method "get_section" {
		c_method_call "sysfs_attribute *" "sysfs_get_module_section" {
						"const char *", "section"
		}
	},
	-- sysfs module attributes iterator
	method "get_attributes" {
	c_source [[
  lua_sysfs_iterator(${this}, sysfs_get_module_attributes, lua_sysfs_attribute_iterator);
]]
        },
	-- sysfs module parameters iterator
	method "get_parms" {
	c_source [[
  lua_sysfs_iterator(${this}, sysfs_get_module_parms, lua_sysfs_attribute_iterator);
]]
        },
	-- sysfs module sections iterator
	method "get_sections" {
	c_source [[
  lua_sysfs_iterator(${this}, sysfs_get_module_sections, lua_sysfs_attribute_iterator);
]]
        },

	--
	-- lua binding specific methods for accessing 'struct sysfs_module' members
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
}
