class GridGem

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

  # ColorsToPixels = {
  #   GridGem::Colors::Blue => Magick::Pixel.new(
  #     75 / 255.0 * Magick::QuantumRange,
  #     206 / 255.0 * Magick::QuantumRange,
  #     239 / 255.0 * Magick::QuantumRange,
  #     1.0,
  #   ),
  #   GridGem::Colors::Brown => Magick::Pixel.new(
  #     95 / 255.0 * Magick::QuantumRange,
  #     62 / 255.0 * Magick::QuantumRange,
  #     62 / 255.0 * Magick::QuantumRange,
  #     1.0,
  #   ),
  #   GridGem::Colors::Green => Magick::Pixel.new(
  #     34 / 255.0 * Magick::QuantumRange,
  #     119 / 255.0 * Magick::QuantumRange,
  #     17 / 255.0 * Magick::QuantumRange,
  #     1.0,
  #   ),
  #   GridGem::Colors::Purple => Magick::Pixel.new(
  #     134 / 255.0 * Magick::QuantumRange,
  #     27 / 255.0 * Magick::QuantumRange,
  #     190 / 255.0 * Magick::QuantumRange,
  #     1.0,
  #   ),
  #   GridGem::Colors::Red => Magick::Pixel.new(
  #     204 / 255.0 * Magick::QuantumRange,
  #     40 / 255.0 * Magick::QuantumRange,
  #     49 / 255.0 * Magick::QuantumRange,
  #     1.0,
  #   ),
  #   GridGem::Colors::Yellow => Magick::Pixel.new(
  #     229 / 255.0 * Magick::QuantumRange,
  #     188 / 255.0 * Magick::QuantumRange,
  #     49 / 255.0 * Magick::QuantumRange,
  #     1.0,
  #   ),
  #   GridGem::Colors::Skull => Magick::Pixel.new(
  #     253 / 255.0 * Magick::QuantumRange,
  #     253 / 255.0 * Magick::QuantumRange,
  #     253 / 255.0 * Magick::QuantumRange,
  #     1.0,
  #   ),
  #   GridGem::Colors::ExplodingSkull => Magick::Pixel.new(
  #     214 / 255.0 * Magick::QuantumRange,
  #     150 / 255.0 * Magick::QuantumRange,
  #     140 / 255.0 * Magick::QuantumRange,
  #     1.0,
  #   ),
  #   GridGem::Colors::Unmatchable => Magick::Pixel.new(
  #     44 / 255.0 * Magick::QuantumRange,
  #     51 / 255.0 * Magick::QuantumRange,
  #     48 / 255.0 * Magick::QuantumRange,
  #     1.0,
  #   ),
  # }

  def self.colors_to_pixel_sets
    @_colors_to_pixel_sets ||= begin
      data = {}
      GridGem::Colors::All.each do |color|
        data[color] = []

        image = Magick::ImageList.new("lib/gem_images/#{color}.png")
        total_pixels = image.columns + image.rows
        valid_radius = [image.columns / 2, image.rows / 2].min - 10
        center = [image.columns / 2, image.rows / 2]
        sampled_pixels = []

        while sampled_pixels.length < total_pixels * 0.1
          x = (image.columns * rand).to_i
          y = (image.rows * rand).to_i
          distance_from_center = Math.sqrt(((x - center[0]) ** 2) + ((y - center[1]) ** 2))
          if distance_from_center <= valid_radius
            sampled_pixel = image.pixel_color(x, y)

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

      # data.each do |color, pixels|
      #   puts color
      #   pixels.each do |pixel|
      #     puts "\t#{pixel.to_s}"
      #   end
      # end

      uniqued_data = {}
      GridGem::Colors::All.each do |color|
        uniqued_data[color] = []
        data[color].each do |pixel|
          any_match = (GridGem::Colors::All - [color]).any? do |other_color|
            data[other_color].any? do |other_pixel|
              pixel.fcmp(other_pixel, Magick::QuantumRange * Screen::ImageMagickFuzz)
            end
          end

          if !any_match
            uniqued_data[color] << pixel
          end
        end
      end

      # uniqued_data.each do |color, pixels|
      #   puts color
      #   pixels.each do |pixel|
      #     puts "\t#{pixel.to_s}"
      #   end
      # end

      uniqued_data
    end
  end

  def self.from_coords(rmagick_image:, coords:)
    match_counts = {}
    coords.sample(coords.length * 0.1).each do |coord|
      pixel = rmagick_image.pixel_color(coord.first, coord.last)
      GridGem::Colors::All.each do |color|
        any_match = GridGem.colors_to_pixel_sets[color].any? do |color_pixel|
          pixel.fcmp(color_pixel, Magick::QuantumRange * Screen::ImageMagickFuzz)
        end

        match_counts[color] ||= 0
        match_counts[color] +=1 if any_match
      end
    end

    # pp match_counts

    # byebug

    color = match_counts.to_a.sort_by(&:last).last.first

    fail('could not detect color') if color.nil?

    return GridGem.new(color: color)
  end

  attr_accessor :color

  def initialize(color:)
    self.color = color
  end

end
