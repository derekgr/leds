## Parts

- Raspberry Pi with [Occidentalis](http://learn.adafruit.com/adafruit-raspberry-pi-educational-linux-distro/occidentalis-v0-dot-2) for hardware SPI
- [Addressable RGB LED strip](http://adafruit.com/products/306)
- A 5V power supply with ~500mA for the Raspberry Pi and ~2A per meter of strip; I used [this](https://www.adafruit.com/products/658)

## Instructions

Pretty much [this](http://learn.adafruit.com/light-painting-with-raspberry-pi), TL;DR:

- Connect the Raspberry Pi and the LED strip to power; I connected the +5V GPIO pin on the Pi into the power supply as well as +5V on the LED strip, as per
the Adafruit article.
- Connect the Pi's [MOSI and SCLK pins to DI and CI on the LED strip, respectively](http://learn.adafruit.com/assets/1589)
- `apt-get install ruby ruby-dev imagemagick libmagickwand-dev`
- :coffee: break
- `gem install sinatra thin rmagick`
- `sudo ruby app.rb`

```
DELETE / - all leds off
PUT /i/r/g/b - set leds at position i to [r,g,b] and change immediately
POST / - set multiple positions at once; pass a list of position,r,g,b in the body:
i,r1,g1,b1
j,r2,g2,g2
```
