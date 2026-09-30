### AnyKernel3 Ramdisk Mod Script
### whyred (Redmi Note 5 Pro / SDM636)

properties() { '
kernel.string=C9 Custom Kernel for Whyred
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=whyred
device.name2=Whyred
device.name3=WHYRED
device.name4=tulip
device.name5=Tulip
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables (UPPERCASE required by ak3-core.sh setup_ak)
BLOCK=/dev/block/bootdevice/by-name/boot;
IS_SLOT_DEVICE=0;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

## AnyKernel install
. tools/ak3-core.sh;

# Banner
ui_print " ";
ui_print "**************************************";
ui_print "*  C9 Custom Kernel for Whyred       *";
ui_print "*  KernelSU-Next v33294              *";
ui_print "**************************************";
ui_print " ";

split_boot;
flash_boot;
## end install