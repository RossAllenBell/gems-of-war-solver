require 'RMagick'
require 'memoist'
require 'byebug'

Dir[__dir__ + '/lib/**/*.rb'].each &method(:require)

Game.set_debug(true)

game = Game.new
run_id = Time.now.to_i

temp_file_name = "gems_of_war_solver.rb.#{run_id}.png"
temp_file_path = "/tmp/#{temp_file_name}"
saved_windowid = nil

puts "run_id: #{run_id}"
puts "temp_file_path: #{temp_file_path}"

input = nil
while input != 'q'
  print "windowid#{" (#{saved_windowid})" unless saved_windowid.nil?}, image file, or q: "
  input = gets.strip

  input = saved_windowid if input.length == 0 && saved_windowid.to_s.length > 0

  if input.to_s == input.to_i.to_s
    `screencapture -o -x -l #{input} /tmp/#{temp_file_name}`
    file_path = temp_file_path
    saved_windowid = input
  elsif input == 'q'
    break
  else
    file_path = input
  end

  begin
    image = Magick::ImageList.new(file_path)
  rescue ArgumentError, Magick::ImageMagickError => e
    puts e.message
  end

  puts ''

  if !image.nil?
    screen = Screen.new(rmagick_image: image)
    game.update(screen: screen)

    puts '' if Game.debug?

    game.print_state

    puts ''

    image.destroy!
    image = nil
  end
end

puts 'Exiting...'
