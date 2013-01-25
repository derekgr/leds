class LedStrip
  # gamma correction + 7-bit color conversion
  # https://gist.github.com/3309494
  @@gamma = 256.times.map { |i|
    0x80 | ((i.to_f/255.0)**2.5 * 127.0 + 0.5).to_i
  }

  def initialize(device="/dev/spidev0.0",length=32)
    @device = device
    @length = length
    @dev = File.open(device, "w")
    clear!
  end

  def clear!
    # r,g,b per pixel + 1 latch byte at the end
    @bytes = [@@gamma[0],@@gamma[0],@@gamma[0]]*@length + [0]
  end

  def []=(offset, v)
    r,g,b = v
    i = offset*3
    # byte order to device is g,r,b
    @bytes[i] = @@gamma[g]
    @bytes[i+1] = @@gamma[r]
    @bytes[i+2] = @@gamma[b]
  end

  def write!
    @dev = File.open(@device, "w") if (@dev.nil? || @dev.closed?)
    @dev.write @bytes.pack("c*")
    @dev.flush
  end

  def close
    @dev.close
  end

  # silly demo, techno party
  def chaser(interval=0.03)
    i = 0
    step = 1
    glow = 0
    glow_step = 1
    while true do
      while i >= 0 && i < 32 do
        self.clear!
        self[i] = [rand(255-glow),rand(255-glow),rand(255-glow)]
        self.write!
        i = i + step
        sleep(interval)
        glow += glow_step*rand(10)
        if glow > 230
          glow = 230
          glow_step = -1
        end
        if glow < 0
          glow = 0
          glow_step = 1
        end
      end

      # reverse direction
      i = i - step
      step *= -1
    end
  end
end
