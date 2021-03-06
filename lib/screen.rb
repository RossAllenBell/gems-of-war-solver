class Screen
  extend Memoist

  ImageMagickFuzz = 0.03
  ImageMagickFuzzGrayDetection = 0.02
  MeasureNthPixel = 32
  GrayConfidence = 0.5

  GridLength = 8

  def self.gem_grid_top_gray_pixels
    @_gem_grid_top_gray_pixels ||= begin
      image = Magick::ImageList.new('lib/gem_images/gem_grid_top_gray.png')
      pixels = []
      (0..image.columns - 1).each do |x|
        (0..image.rows - 1).each do |y|
          pixels << image.pixel_color(x, y)
        end
      end
      pixels.uniq!
    end
  end

  def self.gem_grid_right_gray_pixels
    @_gem_grid_right_gray_pixels ||= begin
      image = Magick::ImageList.new('lib/gem_images/gem_grid_right_gray.png')
      pixels = []
      (0..image.columns - 1).each do |x|
        (0..image.rows - 1).each do |y|
          pixels << image.pixel_color(x, y)
        end
      end
      pixels.uniq!
    end
  end

  def self.gem_grid_bottom_gray_pixels
    @_gem_grid_bottom_gray_pixels ||= begin
      image = Magick::ImageList.new('lib/gem_images/gem_grid_bottom_gray.png')
      pixels = []
      (0..image.columns - 1).each do |x|
        (0..image.rows - 1).each do |y|
          pixels << image.pixel_color(x, y)
        end
      end
      pixels.uniq!
    end
  end

  def self.gem_grid_left_gray_pixels
    @_gem_grid_left_gray_pixels ||= begin
      image = Magick::ImageList.new('lib/gem_images/gem_grid_left_gray.png')
      pixels = []
      (0..image.columns - 1).each do |x|
        (0..image.rows - 1).each do |y|
          pixels << image.pixel_color(x, y)
        end
      end
      pixels.uniq!
    end
  end

  def self.is_pixel_gem_grid_gray?(rmagick_pixel:, direction:)
    return Screen.gem_grid_top_gray_pixels.any? do |pixel|
      rmagick_pixel.fcmp(pixel, Magick::QuantumRange * Screen::ImageMagickFuzzGrayDetection)
    end if direction == :top

    return Screen.gem_grid_right_gray_pixels.any? do |pixel|
      rmagick_pixel.fcmp(pixel, Magick::QuantumRange * Screen::ImageMagickFuzzGrayDetection)
    end if direction == :right

    return Screen.gem_grid_bottom_gray_pixels.any? do |pixel|
      rmagick_pixel.fcmp(pixel, Magick::QuantumRange * Screen::ImageMagickFuzzGrayDetection)
    end if direction == :bottom

    return Screen.gem_grid_left_gray_pixels.any? do |pixel|
      rmagick_pixel.fcmp(pixel, Magick::QuantumRange * Screen::ImageMagickFuzzGrayDetection)
    end if direction == :left

    fail(direction)
  end

  attr_accessor(
    :rmagick_image,
    :cached_gem_grid_top_y,
    :cached_gem_grid_right_x,
    :cached_gem_grid_bottom_y,
    :cached_gem_grid_left_x,
  )

  def initialize(rmagick_image:, cached_gem_grid_top_y: nil, cached_gem_grid_right_x: nil, cached_gem_grid_bottom_y: nil, cached_gem_grid_left_x: nil)
    self.rmagick_image = rmagick_image
    self.cached_gem_grid_top_y = cached_gem_grid_top_y
    self.cached_gem_grid_right_x = cached_gem_grid_right_x
    self.cached_gem_grid_bottom_y = cached_gem_grid_bottom_y
    self.cached_gem_grid_left_x = cached_gem_grid_left_x
  end

  def gem_grid_top_y
    self.cached_gem_grid_top_y ||= begin
      print 'gem_grid_top_y: ' if Game.debug?

      row = 0
      while row < self.rmagick_image.rows
        coords = (gem_grid_left_x..gem_grid_right_x).map do |x|
          Coordinate.new(x: x, y: row)
        end
        coords = coords.select.with_index{|coord, index| index % Screen::MeasureNthPixel == 0}

        if self.are_coords_gem_grid_gray?(coords: coords, direction: :top)
          break
        end

        row += 1
      end

      puts row if Game.debug?

      row
    end
  end

  def gem_grid_bottom_y
    self.cached_gem_grid_bottom_y ||= begin
      print 'gem_grid_bottom_y: ' if Game.debug?

      row = self.rmagick_image.rows - 1
      while row >= 0
        coords = (gem_grid_left_x..gem_grid_right_x).map do |x|
          Coordinate.new(x: x, y: row)
        end
        coords = coords.select.with_index{|coord, index| index % Screen::MeasureNthPixel == 0}

        if self.are_coords_gem_grid_gray?(coords: coords, direction: :bottom)
          break
        end

        row -= 1
      end

      puts row if Game.debug?

      row
    end
  end
  memoize :gem_grid_bottom_y

  def gem_grid_left_x
    self.cached_gem_grid_left_x ||= begin
      print 'gem_grid_left_x: ' if Game.debug?

      col = 0
      while col < self.rmagick_image.columns
        coords = (0..self.rmagick_image.rows - 1).map do |y|
          Coordinate.new(x: col, y: y)
        end
        coords = coords.select.with_index{|coord, index| index % Screen::MeasureNthPixel == 0}

        if self.are_coords_gem_grid_gray?(coords: coords, direction: :left)
          break
        end

        col += 1
      end

      puts col if Game.debug?

      col
    end
  end
  memoize :gem_grid_left_x

  def gem_grid_right_x
    self.cached_gem_grid_right_x ||= begin
      print 'gem_grid_right_x: ' if Game.debug?

      col = self.rmagick_image.columns - 1
      while col >= 0
        coords = (0..self.rmagick_image.rows - 1).map do |y|
          Coordinate.new(x: col, y: y)
        end
        coords = coords.select.with_index{|coord, index| index % Screen::MeasureNthPixel == 0}

        if self.are_coords_gem_grid_gray?(coords: coords, direction: :right)
          break
        end

        col -= 1
      end

      puts col if Game.debug?

      col
    end
  end
  memoize :gem_grid_right_x

  def are_coords_gem_grid_gray?(coords:, direction:)
    results = coords.map do |coord|
      if Screen.is_pixel_gem_grid_gray?(rmagick_pixel: self.rmagick_image.pixel_color(coord.x, coord.y), direction: direction)
        1
      else
        0
      end
    end

    # puts results.reduce(:+) / results.size.to_f

    return results.reduce(:+) / results.size.to_f >= Screen::GrayConfidence
  end

  def gem_at(x:, y:)
    ScreenGem.from_coords(
      rmagick_image: self.rmagick_image,
      coords: pixel_coords_for_gem_at(x: x, y: y),
    )
  end
  memoize :gem_at

  def pixel_coords_for_gem_at(x:, y:)
    start_x = gem_grid_left_x + (x * gem_offset_x)
    end_x = start_x + gem_offset_x
    start_y = gem_grid_top_y + (y * gem_offset_y)
    end_y = start_y + gem_offset_y

    valid_radius = (gem_offset_x / 2) - 10
    center = Coordinate.new(x: start_x + (gem_offset_x / 2), y: start_y + (gem_offset_y / 2))

    coords = []
    (start_x..end_x).each do |x|
      (start_y..end_y).each do |y|
        coord = Coordinate.new(x: x, y: y)
        if center.distance_from(coordinate: coord) <= valid_radius
          coords << coord
        end
      end
    end

    return coords
  end
  memoize :pixel_coords_for_gem_at

  def gem_offset_x
    ((self.gem_grid_right_x - self.gem_grid_left_x) / Board::Width.to_f).to_i
  end
  memoize :gem_offset_x

  def gem_offset_y
    ((self.gem_grid_bottom_y - self.gem_grid_top_y) / Board::Height.to_f).to_i
  end
  memoize :gem_offset_y

end
