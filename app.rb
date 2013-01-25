#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__))

require 'sinatra'
require 'leds'

strip = LedStrip.new

put '/:i/:r/:g/:b' do
  strip[params[:i].to_i] = [params[:r].to_i, params[:g].to_i, params[:b].to_i]
  strip.write!
end

post '/' do
  request.body.each_line do |l|
    i,r,g,b = l.chomp.split(',').map(&:to_i)
    strip[i] = [r,g,b]
  end

  strip.write!
end

delete '/' do
  strip.clear!
  strip.write!
end

Signal.trap("INT") do
  strip.clear!
  strip.write!
  strip.close
end
