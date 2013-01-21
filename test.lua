local sysfs = require"sysfs"

print(sysfs.get_mnt_path())

class = sysfs.class.open("block")
print(class)
dlist = class:get_devices()
print(dlist)
print(class:for_each_device())
for x in class:for_each_device() do print(x) end
class:close()
