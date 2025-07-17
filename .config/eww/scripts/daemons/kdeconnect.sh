#!/bin/sh
# Reachable + battery state of device linked with KDEconnect
# This helped a lot:
# https://github.com/haideralipunjabi/polybar-kdeconnect/blob/master/polybar-kdeconnect.sh

# Find (first) device ID
deviceid="$(busctl --user call org.kde.kdeconnect.daemon /modules/kdeconnect org.kde.kdeconnect.daemon devices | cut -d'"' -f2 | head -1)"

# TODO (someday): Multiple devices
# for deviceid in $(busctl --user call org.kde.kdeconnect.daemon /modules/kdeconnect org.kde.kdeconnect.daemon devices | cut -d'"' -f2); do
#     echo $deviceid
# done

update() {
  # name="$(busctl --user get-property org.kde.kdeconnect.daemon "/modules/kdeconnect/devices/$deviceid" org.kde.kdeconnect.device name | cut -d'"' -f2)"
  reachable="$(busctl --user get-property org.kde.kdeconnect.daemon "/modules/kdeconnect/devices/$deviceid" org.kde.kdeconnect.device isReachable | cut -d' ' -f2)"
  if [[ "$reachable" == "true" ]]; then
    battery="$(busctl --user get-property org.kde.kdeconnect.daemon "/modules/kdeconnect/devices/${deviceid}/battery" org.kde.kdeconnect.device.battery charge | cut -d' ' -f2)"
    eww update kdeconnect-battery=$battery kdeconnect-reachable=1
  else
    eww update kdeconnect-reachable=0
  fi
}

if [ "$1" == "oneshot" ]; then
    update
    exit
fi

while true; do
  update
  sleep 15
done

# To get all methods, properties and signals use this:
# busctl --user introspect org.kde.kdeconnect.daemon "/modules/kdeconnect/devices/$deviceid"

# TODO (someday) Instead of polling, we could subscribe to 'reachable' changes
# dbus-monitor "type='signal',interface='org.kde.kdeconnect.device',member='reachableChanged'" |
# while read -r line; do
#     if [[ "$line" == *"boolean true"* ]]; then
#         echo "Device is reachable"
#     elif [[ "$line" == *"boolean false"* ]]; then
#         echo "Device is not reachable"
#     fi
# done
