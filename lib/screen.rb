  class Screen
    extend Memoist

  GemGridDarkGray = Magick::Pixel.new(
    78 / 255.0 * Magick::QuantumRange,
    79 / 255.0 * Magick::QuantumRange,
    81 / 255.0 * Magick::QuantumRange,
    1.0,
  )

  GemGridLightGray = Magick::Pixel.new(
    113 / 255.0 * Magick::QuantumRange,
    106 / 255.0 * Magick::QuantumRange,
    108 / 255.0 * Magick::QuantumRange,
    1.0,
  )

  GridLength = 8

  def self.is_pixel_gem_grid_gray?(rmagick_pixel:)
    return true if rmagick_pixel.fcmp(GemGridLightGray, Magick::QuantumRange * 0.05)
    return true if rmagick_pixel.fcmp(GemGridDarkGray, Magick::QuantumRange * 0.05)
    return false
  end

  attr_accessor(
    :rmagick_image,
  )

  def initialize(rmagick_image:)
    self.rmagick_image = rmagick_image
  end

  def gem_grid_top_y
    row = 0
    while row < self.rmagick_image.rows
      coords = (0..self.rmagick_image.columns - 1).map do |x|
        [x, row]
      end
      coords = coords.sample(coords.length * 0.1)

      if self.are_coords_gem_grid_gray?(coords: coords)
        break
      end

      row += 1
    end
    row
  end
  memoize :gem_grid_top_y

  def gem_grid_bottom_y
    row = self.rmagick_image.rows - 1
    while row >= 0
      coords = (0..self.rmagick_image.columns - 1).map do |x|
        [x, row]
      end
      coords = coords.sample(coords.length * 0.1)

      if self.are_coords_gem_grid_gray?(coords: coords)
        break
      end

      row -= 1
    end
    row
  end
  memoize :gem_grid_bottom_y

  def gem_grid_left_x
    col = 0
    while col < self.rmagick_image.columns
      coords = (0..self.rmagick_image.rows - 1).map do |y|
        [col, y]
      end
      coords = coords.sample(coords.length * 0.1)

      if self.are_coords_gem_grid_gray?(coords: coords)
        break
      end

      col += 1
    end
    col
  end
  memoize :gem_grid_left_x

  def gem_grid_right_x
    col = self.rmagick_image.columns - 1
    while col >= 0
      coords = (0..self.rmagick_image.rows - 1).map do |y|
        [col, y]
      end
      coords = coords.sample(coords.length * 0.1)

      if self.are_coords_gem_grid_gray?(coords: coords)
        break
      end

      col -= 1
    end
    col
  end
  memoize :gem_grid_right_x

  def are_coords_gem_grid_gray?(coords:)
    results = coords.map do |coord|
      if Screen.is_pixel_gem_grid_gray?(rmagick_pixel: self.rmagick_image.pixel_color(coord.first, coord.last))
        1
      else
        0
      end
    end

    return results.reduce(:+) / results.size.to_f >= 0.25
  end

  def gem_at(x:, y:)
    GridGem.from_coords(
      rmagick_image: self.rmagick_image,
      coords: pixel_coords_for_gem_at(x: x, y: y)
    )
  end
  memoize :gem_at

  def pixel_coords_for_gem_at(x:, y:)
    start_x = gem_grid_left_x + (x * gem_offset)
    end_x = start_x + gem_offset
    start_y = gem_grid_top_y + (y * gem_offset)
    end_y = start_y + gem_offset

    coords = []
    (start_x..end_x).each do |x|
      (start_y..end_y).each do |y|
        coords << [x,y]
      end
    end

    return coords
  end
  memoize :pixel_coords_for_gem_at

  def gem_offset
    ((self.gem_grid_bottom_y - self.gem_grid_top_y) / 8.0).to_i
  end
  memoize :gem_offset

end
