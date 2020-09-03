# Homebridge / Raspberry Shake Earthquake Sensor

This uses the Homebridge framework and the Raspberry Shake Earthquake monitor (https://raspberryshake.net/) to expose a HomeKit motion sensor which is triggered when an earthquake is detected.

## Installation

To simplify the integration of the Raspberry Shake earthquake monitoring code and the Homebridge sensor code, everything
is wrapped up in a simple to run Docker image. To run using Docker simply type:

```
docker run --network host registry.minkebox.net/minkebox/homebridge_raspberryshake
```

## Configuration

The way the data from the Raspberry Shake is analyzed is controlled by a number of environment variables. Sensible
defaults are set, but they can be overridden.

| Environment | Description      |
|-------------|--------------------|
| STATION     | Your station name |
| LOW         | Lowpass filter |
| HIGH        | Highpass filter |
| STA         | Short term average |
| LTA         | Long term average |
| THRESHOLD   | Trigger threshold |
| RESET       | Reset threshold |

A full explaination of how to change these can be found at https://raspishake.github.io/rsudp/settings.html#alert-sta-lta-earthquake-detection-trigger

## Receiving data from your Raspberry Shake

Data is sent, using UDP port 8888, from your Raspberry Shake to this application. The Shake should use the *Datacast*
feature (see https://manual.raspberryshake.org/udp.html).

## Why?

While earthquakes, one's that matter, are quite obvious, an earthquake sensor allows you to activate scenes in your home when one is detected. For example, you might turn on lights, shutdown heating, or unlock doors; all things to keep you safe and aid possibly evacuation.
