#! /bin/sh

if [ "${BRIDGE_USERNAME}" = "" ]; then
  BRIDGE_USERNAME="0A:34:52:83:88:1A"
fi
if [ "${BRIDGE_PIN}" = "" ]; then
  BRIDGE_PIN="111-11-111"
fi
if [ "${BRIDGE_SETUPID}" = "" ]; then
  BRIDGE_SETUPID="0000"
fi

if [ "${STATION}" = "" ]; then
  STATION="R36B8"
fi
if [ "${LOW}" = "" ]; then
  LOW=9
fi
if [ "${HIGH}" = "" ]; then
  HIGH=0.8
fi
if [ "${STA}" = "" ]; then
  STA=6
fi
if [ "${LTA}" = "" ]; then
  LTA=30
fi
if [ "${THRESHOLD}" = "" ]; then
  THRESHOLD=4.5
fi
if [ "${RESET}" = "" ]; then
  RESET=0.5
fi

cat > /root/homebridge/config.json << __EOF__
{
  "bridge": {
    "name": "Raspberry Shake",
    "username": "${BRIDGE_USERNAME}",
    "port": 51826,
    "pin": "${BRIDGE_PIN}",
    "setupID": "${BRIDGE_SETUPID}"
  },
  "description": "",
  "accessories": [
    {
      "accessory": "http-motion-sensor",
      "name": "Earthquake Detected",
      "port": 8889,
      "bind_ip": "127.0.0.1"
    }
  ],
  "platforms": []
}
__EOF__

cat > /root/.config/rsudp/rsudp_settings.json << __EOF__
{
  "settings": {
    "port": 8888,
    "station": "${STATION}",
    "output_dir": "/root/rsudp",
    "debug": true
  },
  "printdata": {
    "enabled": false
  },
  "write": {
    "enabled": false,
    "channels": ["all"]
  },
  "plot": {
    "enabled": true,
    "duration": 30,
    "spectrogram": true,
    "fullscreen": false,
    "kiosk": false,
    "eq_screenshots": true,
    "channels": ["HZ"],
    "deconvolve": true,
    "units": "CHAN"
  },
  "forward": {
    "enabled": false,
    "address": "192.168.1.254",
    "port": 8888,
    "channels": ["all"]
  },
  "alert": {
    "enabled": true,
    "channel": "HZ",
    "sta": ${STA},
    "lta": ${LTA},
    "threshold": ${THRESHOLD},
    "reset": ${RESET},
    "highpass": ${HIGH},
    "lowpass": ${LOW},
    "deconvolve": false,
    "units": "VEL"
  },
  "alertsound": {
    "enabled": false,
    "mp3file": "doorbell"
  },
  "custom": {
    "enabled": true,
    "codefile": "/root/quake.py",
    "win_override": false
  },
  "tweets": {
    "enabled": false,
    "tweet_images": true,
    "api_key": "n/a",
    "api_secret": "n/a",
    "access_token": "n/a",
    "access_secret": "n/a"
  },
  "telegram": {
    "enabled": false,
    "send_images": true,
    "token": "n/a",
    "chat_id": "n/a"
  },
  "rsam": {
    "enabled": false,
    "quiet": true,
    "fwaddr": false,
    "fwport": false,
    "fwformat": "LITE",
    "channel": "HZ",
    "interval": 10,
    "deconvolve": false,
    "units": "VEL"
  }
}
__EOF__

trap "killall dbus-daemon avahi-daemon node homebridge rs-client sleep; exit" TERM INT

dbus-daemon --system
/usr/sbin/avahi-daemon -D
/root/node_modules/homebridge/bin/homebridge --user-storage-path /root/homebridge --plugin-path /root/plugins &

. /opt/conda/etc/profile.d/conda.sh
conda activate rsudp
rs-client &

sleep 2147483647d &
wait "$!"
