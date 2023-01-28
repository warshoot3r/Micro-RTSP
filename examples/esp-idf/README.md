# Micro-RTSP Example

This example shows how to use the Micro-RTSP library with the Ai-Thinker ESP32-CAM board using the IoT Development Framework from Espressif. This example takes the WiFi Station example from esp-idf and combines it with Micro-RTSP, a MQTT client, and OTA updating.

This example uses MQTT to allow control of the LED flash on the ESP32-CAM. It is also needed for the OTA updating.
This example uses the "simple_ota" example as the basis for the OTA functionality. It relies on a http server to retrieve the binary file.
This example also uses network configuration tweaks from the iperf example.
This example supports multiple simultaneious TCP and UDP clients. All clients will use the same camera settings. Be aware that performance will be greatly reduced with multiple clients.

This project has been tested with esp-idf version [5.0](https://github.com/espressif/esp-idf/releases/v5.0-beta1).

This project epends on the `esp32-camera` library which should be cloned into the `components` folder when this repo is cloned (it is included as a git submodule).

## How to use example

### Configure the project

Open the project configuration menu (`idf.py menuconfig`). 

In the `Example Configuration` menu:

* Set the Wi-Fi configuration.
    * Set `WiFi SSID`.
    * Set `WiFi Password`.
    * Set Single Client Mode. When enabled, the system will reset if a client disconnects. This can help clear up connections and corrupted cameras, useful for DVR setups when only one client is ever connected.
    * Set the MQTT connection [URI](https://iotbyhvm.ooo/using-uris-to-connect-to-a-mqtt-server/)
    * Set your desired framerate.
    * Set vertical and horizontal flipping of the image (depends on how the camera is mounted).
    * Set the frame resolution.

The hostname for the camera is located in the `Component config->LWIP->Local netif hostname`
Additional configuration options for the camera (quality, whitebalance) can be found in `main/esp32cam.cpp`

### NOTE
If you increase the framerate or resolution, you may need to increase `xclk_freq_hz` found in `../../src/OV2640.cpp` above the default 10MHz (20MHz is the maximum). Lower speeds improve stability but increases the frame transfer time from the camera. I've found that 5MHz will only give me 3fps, but 8MHz and below proved to be unstable for many of my cameras. Also, I have one camera that will not reliably work at 20MHz, but seems fine at 10MHz.
Consider setting `fb_count` to 2 to increase framerate at the cost of stability. This is because when set to two, the esp32-camera code will start grabbing the next frame as soon as one has finished, so when this code grabs a frame it is immedaite and fresh. However, this leaves the esp32 constantly grabbing frames, which puts a lot of stress on the camera, PSRAM, and esp32.


### Build and Flash

Build the project and flash it to the board:

Run `idf.py -p PORT flash` to build and flash the project.


Once the project is flashed to the board, you can use the ota_update.py python script to update the ESP32-CAM once it is connected to your WiFi and your MQTT broker.

To update OTA, run `python ota_update.py <SERVER_PORT> <LWIP_LOCAL_HOSTNAME>` where `<SERVER_PORT>` is what to use for the local HTTP server (8443 works fine) and `<LWIP_LOCAL_HOSTNAME>` is the device hostname set in menuconfig.
Example: `python ota_update.py 8443 esp32cam0`

See the Getting Started Guide for all the steps to configure and use the ESP-IDF to build projects.

* [ESP-IDF Getting Started Guide on ESP32](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/index.html)

