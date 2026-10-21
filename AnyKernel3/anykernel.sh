### PA03 AnyKernel3 installer

### AnyKernel setup
# global properties
properties() { '
kernel.string=PA03 BakaSU Kernel by coolzyd9107 & maozi-114
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=pa03
device.name2=k37mv1_64_bsp
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties

### AnyKernel install
# This target uses a non-A/B boot partition and an MTK by-name path.
BLOCK=boot;
IS_SLOT_DEVICE=0;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

# Replace only the kernel and preserve the existing ramdisk.
split_boot;
flash_boot;
