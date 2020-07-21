require 'RMagick'
require 'memoist'
require 'byebug'

Dir[__dir__ + '/lib/**/*.rb'].each &method(:require)

screenshot_filename = ARGV.first || fail('Expected screenshot filename as arg')

image = Magick::ImageList.new(screenshot_filename)
screen = Screen.new(rmagick_image: image)

(0..Screen::GridLength - 1).each do |y|
  (0..Screen::GridLength - 1).each do |x|
    print screen.gem_at(x: x, y: y).color
    print ', ' unless x == Screen::GridLength - 1
  end
  puts
end
