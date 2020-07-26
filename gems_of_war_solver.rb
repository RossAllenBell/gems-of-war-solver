require 'RMagick'
require 'memoist'
require 'byebug'

Dir[__dir__ + '/lib/**/*.rb'].each &method(:require)

game = Game.new
run_id = Time.now.to_i

temp_file_name = "gems_of_war_solver.rb.#{run_id}.png"
saved_windowid = nil

input = nil
while input != 'q'
  print "windowid#{" (#{saved_windowid})" unless saved_windowid.nil?}, image file, or q: "
  input = gets.strip

  input = saved_windowid if input.length == 0 && saved_windowid.to_s.length > 0

  if input.to_s == input.to_i.to_s
    `screencapture -o -x -l #{input} /tmp/#{temp_file_name}`
    file_name = temp_file_name
    saved_windowid = input
  elsif input == 'q'
    break
  else
    file_name = input
  end

  begin
    image = Magick::ImageList.new(file_name)
  rescue ArgumentError, Magick::ImageMagickError => e
    puts e.message
  end

  puts ''

  if !image.nil?
    screen = Screen.new(rmagick_image: image)
    game.update(screen: screen)

    puts '' if Game::Debug

    game.print_state

    puts ''

    image.destroy!
    image = nil
  end
end

puts 'Exiting...'
