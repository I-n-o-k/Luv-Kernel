#!/system/bin/sh 

# file specs to execute in initd directory - default=*.sh
FSPEC="*.sh"

# initd directory
INITD=/system/etc/init.d

# debug log - set to 1 (one) to write debug information; 0 (zero) to disable
DEBUG="1"

# log file
LOG=/data/local/init.d.log
LogMSG() {
  [ "$DEBUG" = "1" ] && echo "$@" >> $LOG
}

# get date/time
D=$(date)
LogMSG "$D"

# run which filespecs? - check build.prop
F=$(getprop LUV.initd.filespec)
if [ -n "$F" ]; then
   FSPEC="$F"
fi

# see whether we have already executed this script
F=$(getprop LUV.initd.code)
LogMSG "Debug: LUV.initd.code=$F"
if [ "$F" = "0" ]; then
   LogMSG "Initd script already executed. Stopping."
   exit 0
else
   rm -f $LOG # clean the log
   LogMSG "$D"
   LogMSG "Executing initd"
   # set the property to 0 (ie, we have already run this once)
   setprop LUV.initd.code 0
fi

# Mount partitions rw 
mount -o remount,rw /;
mount -o remount,rw /system
sleep 5

# Create the init.d folder if it does not exist
if [ ! -d $INITD ]; then
   LogMSG "Creating $INITD"
   mkdir -p $INITD
fi

sleep 1
chown -R root:root $INITD
sleep 1
chmod -R 0755 $INITD

# Run scripts in init.d folder
LogMSG "FileSpecs=$INITD/$FSPEC"
sleep 1
for FILE in $INITD/$FSPEC; do
  sleep 1
  LogMSG "Running $FILE"
  sh $FILE >/dev/null
done;

# remount partitions ro once finished
mount -o remount,ro /;
mount -o remount,ro /system
LogMSG "Finished!"

