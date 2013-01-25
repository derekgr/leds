require 'RMagick'
require 'open-uri'

class LedImage
  attr_reader :strip

  def initialize(io,strip)
    @image = Magick::ImageList.new
    @image.from_blob(io.read)
    @image.change_geometry("x#{strip.length}") { |cols,rows,img|
      img.resize!(cols,rows)
    }

    STDERR.puts("Image dimensions #{@image.columns}x#{@image.rows}")
    @strip = strip

    # preload pixel data
    @buffer = []
    @image.columns.times do |i|
      row = []
      @image.rows.times do |j|
        color = @image.pixel_color(i,j)
        row << [color.red/257,color.green/257,color.blue/257]
      end
      @buffer << row
    end
  end

  def self.from_file(filename, strip)
    LedImage.new(File.open(filename), strip)
  end

  def self.from_url(url, strip)
    LedImage.new(open(url), strip)
  end

  # render the image as a series of columns with the given time interval between
  def render(column_interval=0.01)
    STDERR.puts("Rendering with #{column_interval}")
    ct = 0
    @buffer.each do |row|
      row.each_with_index do |val,i|
        @strip[i]=val
      end
      @strip.write!
      ct += 1
      sleep(column_interval)
    end

    STDERR.puts("Wrote #{ct} columns.")
  end
end
