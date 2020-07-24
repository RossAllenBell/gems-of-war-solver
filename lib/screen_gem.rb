class ScreenGem

  module Colors
    Blue = 'blue'
    Brown = 'brown'
    Green = 'green'
    Purple = 'purple'
    Red = 'red'
    Yellow = 'yellow'
    Skull = 'skull'
    ExplodingSkull = 'exploding_skull'
    Unmatchable = 'unmatchable'
    All = constants.map{|c| const_get(c)}
  end

  def self.colors_to_pixel_sets
    @_colors_to_pixel_sets ||= begin
      data = {}
      ScreenGem::Colors::All.each do |color|
        data[color] = []

        image = Magick::ImageList.new("lib/gem_images/#{color}.png")
        total_pixels = image.columns + image.rows
        valid_radius = [image.columns / 2, image.rows / 2].min - 10
        center = Coordinate.new(x: image.columns / 2, y: image.rows / 2)

        pixel_coords = (0..image.columns - 1).map do |col|
          (0..image.rows - 1).map do |row|
            Coordinate.new(x: col, y: row)
          end
        end.flatten(1).select.with_index{|coord, index| index % 10 == 0}

        sampled_pixels = []

        pixel_coords.each do |pixel_coord|
          if center.distance_from(coordinate: pixel_coord) <= valid_radius
            sampled_pixel = image.pixel_color(pixel_coord.x, pixel_coord.y)

            if sampled_pixel.alpha > 0

              if !sampled_pixel.fcmp(Magick::Pixel.from_color('black'), Magick::QuantumRange * Screen::ImageMagickFuzz)
                sampled_pixels << sampled_pixel
                sampled_pixels.uniq!
              end
            end
          end
        end

        sampled_pixels.each do |pixel|
          any_match = data[color].any? do |existing_pixel|
            pixel.fcmp(existing_pixel, Magick::QuantumRange * Screen::ImageMagickFuzz)
          end

          if !any_match
            data[color] << pixel
          end
        end
      end

      uniqued_data = {}
      ScreenGem::Colors::All.each do |color|
        uniqued_data[color] = []
        data[color].each do |pixel|
          any_match = (ScreenGem::Colors::All - [color]).any? do |other_color|
            data[other_color].any? do |other_pixel|
              pixel.fcmp(other_pixel, Magick::QuantumRange * Screen::ImageMagickFuzz)
            end
          end

          if !any_match
            uniqued_data[color] << pixel
          end
        end
      end

      uniqued_data
    end
  end

  def self.from_coords(rmagick_image:, coords:)
    match_counts = {}
    coords.select.with_index{|coord, index| index % 10 == 0}.each do |coord|
      pixel = rmagick_image.pixel_color(coord.x, coord.y)
      ScreenGem::Colors::All.each do |color|
        any_match = ScreenGem.colors_to_pixel_sets[color].any? do |color_pixel|
          pixel.fcmp(color_pixel, Magick::QuantumRange * Screen::ImageMagickFuzz)
        end

        match_counts[color] ||= 0
        match_counts[color] +=1 if any_match
      end
    end

    color = match_counts.to_a.sort_by(&:last).last.first

    fail('could not detect color') if color.nil?

    return ScreenGem.new(color: color)
  end

  attr_accessor :color

  def initialize(color:)
    self.color = color
  end

end
