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

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;

## AnyKernel install
. tools/ak3-core.sh;

# Banner (after ak3-core.sh is loaded so ui_print is available)
ui_print " ";
ui_print "**************************************";
ui_print "*  C9 Custom Kernel for Whyred       *";
ui_print "*  KernelSU-Next v33294              *";
ui_print "**************************************";
ui_print " ";

split_boot;
flash_boot;
## end install