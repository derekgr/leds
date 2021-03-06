A light painting experiment: hook a Raspberry Pi to an LED strip, control and script the display over the network.

![:boom: :camel:](https://f.cloud.github.com/assets/60566/96449/147aea60-66ae-11e2-9c8c-d507f145ebbb.png)

## Parts

- Raspberry Pi with [Occidentalis](http://learn.adafruit.com/adafruit-raspberry-pi-educational-linux-distro/occidentalis-v0-dot-2) for hardware SPI driver support
- [Addressable RGB LED strip](http://adafruit.com/products/306)
- A 5V power supply with ~500mA for the Raspberry Pi and ~1.5A per meter of strip at peak current; I used [this](https://www.adafruit.com/products/658), which should be overkill for 1 strip

## Instructions

Inspired by [this Adafruit article](http://learn.adafruit.com/light-painting-with-raspberry-pi). TL;DR:

- Connect the Raspberry Pi and the LED strip to power; I connected the +5V GPIO pin on the Pi into the power supply as well as +5V on the LED strip, as per
the Adafruit article.
- Connect the Pi's [MOSI and SCLK pins to DI and CI on the LED strip, respectively](http://learn.adafruit.com/assets/1589)
- On the Raspberry Pi:
  - `apt-get install ruby ruby-dev imagemagick libmagickwand-dev`
  - :coffee: break while those install
  - `gem install sinatra thin rmagick`
  - another :coffee: break, writing to SD is slow
  - `sudo ./app.rb` - you need to run as root to access the SPI device

Then send commands to the LED strip over HTTP.

```sh
# all leds off
> curl -X DELETE http://raspberry-pi:4567/

# led at position 5 to red
> curl -X PUT http://raspberry-pi:4567/5/255/0/0

# led at position i to [r,g,b]
> curl -X PUT http://raspberry-pi:4567/i/r/g/b

# set mutiple positions at once
> curl -X POST --data-binary @- http://raspberry-pi:4567/
5,255,0,0
6,255,255,255
7,0,0,255
11,255,0,0
12,255,255,255
13,0,0,255
17,255,0,0
18,255,255,255
19,0,0,255
21,255,0,0
22,255,255,255
23,0,0,255
^D

# :boom:
> curl -X POST http://raspberry-pi:4567/boom

# :boom: :camel: in 0.5s stripes
> curl -X POST --data-binary @- http://raspberry-pi:4567/urls
urls=https://github.com/images/icons/emoji/boom.png,https://github.com/images/icons/emoji/camel.png&timeout=0.5
^D
```

## Now What?

- Take a long-exposure photo in a dark location of you moving around the strip while it's displaying images. See what happens. It helps to have a second person!
- Wire the strip and the Pi with a mobile power source to a stable, mobile platform (like the bicycle platform in the Adafruit article), and have someone with a camera
and a computer script cool effects while you slowly bike back and forth.
