mkdir -p /media/mass_storage/gpuovl/upper
mkdir -p /media/mass_storage/gpuovl/lower
mkdir -p /media/mass_storage/gpuovl/work
      
mount --bind /usr/share/ /media/mass_storage/gpuovl/lower
mount -o remount,bind,ro /media/mass_storage/gpuovl/lower/
      
mount -t overlay overlay -o lowerdir=/media/mass_storage/gpuovl/lower,upperdir=/media/mass_storage/gpuovl/upper,workdir=/media/mass_storage/gpuovl/work /usr/share