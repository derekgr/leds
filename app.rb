#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__))

require 'leds'
require 'leds/image'

strip = LedStrip.new

unless ENV['SAVE_LEDS']
  at_exit do
    strip.reset!
    strip.close
  end
end

require 'sinatra'

# set a pixel
put '/:i/:r/:g/:b' do
  strip[params[:i].to_i] = [params[:r].to_i, params[:g].to_i, params[:b].to_i]
  strip.write!
end

# set many pixels
post '/' do
  body = request.body.read
  body.split("\n").each do |l|
    next unless l =~ /^\d+,\d+,\d+,\d+$/
    i,r,g,b = l.chomp.split(',').map(&:to_i)
    strip[i] = [r,g,b]
  end

  strip.write!
end

# reset
delete '/' do
  strip.reset!
end

# :boom:
post '/boom' do
  boom = LedImage.from_url("https://github.com/images/icons/emoji/boom.png", strip)
  boom.render(0.01)
  sleep(1)
  strip.reset!
end

# download the image and render it
post '/url' do
  url = params[:url]
  STDERR.puts("Displaying #{url}")

  timeout = params[:timeout].to_f || 0.01
  LedImage.from_url(url, strip).render(timeout) if url
end

# download a series of images to precache, then render in sequence
post '/urls' do
  urls = params[:urls]
  timeout = params[:timeout].to_f || 0.01
  images = urls.split(',').map do |url|
    STDERR.puts("Loading #{url}")
    image = LedImage.from_url(url, strip)
    STDERR.puts("Preloaded #{url}")
    image
  end

  STDERR.puts("Preloaded all images.")
  images.each do |image|
    image.render(timeout)
  end
end
