#!/bin/bash

esp+=( "esp32cam0" )
esp+=( "esp32cam1" )
esp+=( "esp32cam2" )
esp+=( "esp32cam3" )

#setup the build envrionment
. ~/esp/esp-idf/export.sh

for e in ${esp[@]}; do
  echo "Updating $e..."
  
  #update the SDK with the desired hostname (note that other fields can be changed here as well, like horizontal/vertical as needed)
  sed -i "s/CONFIG_LWIP_LOCAL_HOSTNAME=.*/CONFIG_LWIP_LOCAL_HOSTNAME=\"$e\"/" sdkconfig
  
  #build it
  idf.py fullclean build
  
  #update the camera (note, best to ensure a client is connected before updating to avoid tripping the watchdog)
  python ota_update.py 8443 $e
done

