local sysfs = require"sysfs"

print(sysfs.get_mnt_path())

class = sysfs.class.open("block")
print(class)
dlist = class:get_devices()
print(dlist)
class:close()
