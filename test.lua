local sysfs = require"sysfs"

print(sysfs.get_mnt_path())

class = sysfs.class.open("block")
print(class)
class:close()
