# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Luv-2.3
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=kenzo
device.name2=kate
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;

## AnyKernel install
dump_boot;

# begin ramdisk changes

# check for system_root #
THE_ROOT="";
#ls -all /system/
#ls -all /system/etc/
#ls -all /system_root/
#ls -all /system_root/etc/
#ls -all $home
if [ -d "/system_root/system/" -a -d "/system_root/etc/" -a -e "/system_root/init.rc" ]; then
   ui_print "- custom tuneble cpu governor and init.d supporting ";
   ui_print "- Dev : @inok53"
   ui_print "- Changelog";
   ui_print "- OC A53 Cores to 1.61Ghz";
   ui_print "- OC Gpu to 710Mhz"
   ui_print "- Switch To Dynamic FPS 61-62hz";
   ui_print "- Fine Tuned Mitigation Freq and Temp";
   ui_print "- Add Devfreq Boosting Driver";
   ui_print "- Fine Tuned Voltages and Clocks(CPU/GPU/DDR bus)";
   ui_print "- New Custom Tuned Cpu Governor";
   ui_print "- Disable a lot of debugging";
   ui_print "- Disable Tracing as much as possible";
   ui_print "- Can't support thermal-engine (please dont use any thermal mod)";
   ui_print "- Remove wireguard on kernel";
   echo " " >> /tmp/recovery.log;
   echo "- Mounting /system_root in read-write mode..." >> /tmp/recovery.log;
   THE_ROOT="/system_root";
   THE_SYSTEM="/system";
   mount -o rw,remount $THE_ROOT;
   mount -o rw,remount $THE_SYSTEM;
   sleep 1
   THE_ROOT=$THE_ROOT"/";
   THE_SYSTEM=$THE_SYSTEM"/"
   echo "- Copying files manually..." >> /tmp/recovery.log;
   cp -fp $home/ramdisk/init.luv.rc $THE_ROOT;
   cp -af $home/ramdisk/sbin/ $THE_ROOT;
   cd $THE_ROOT;
   sleep 1
   cd /system
   rm -rf /etc/thermal-engine.conf
   rm -rf /vendor/etc/thermal-engine.conf
else
   echo "- NOT system-as-root ..." >> /tmp/recovery.log;
fi
# end: system-as-root #

# init.rc
backup_file "$THE_ROOT"init.rc;
insert_line "$THE_ROOT"init.rc "init.luv.rc" before "on early-init" "import /init.luv.rc";

# end ramdisk changes

write_boot;
## end install


