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
  end

  ColorsToPixels = {
    GridGem::Colors::Blue => Magick::Pixel.new(
      75 / 255.0 * Magick::QuantumRange,
      206 / 255.0 * Magick::QuantumRange,
      239 / 255.0 * Magick::QuantumRange,
      1.0,
    ),
    GridGem::Colors::Brown => Magick::Pixel.new(
      95 / 255.0 * Magick::QuantumRange,
      62 / 255.0 * Magick::QuantumRange,
      62 / 255.0 * Magick::QuantumRange,
      1.0,
    ),
    GridGem::Colors::Green => Magick::Pixel.new(
      34 / 255.0 * Magick::QuantumRange,
      119 / 255.0 * Magick::QuantumRange,
      17 / 255.0 * Magick::QuantumRange,
      1.0,
    ),
    GridGem::Colors::Purple => Magick::Pixel.new(
      134 / 255.0 * Magick::QuantumRange,
      27 / 255.0 * Magick::QuantumRange,
      190 / 255.0 * Magick::QuantumRange,
      1.0,
    ),
    GridGem::Colors::Red => Magick::Pixel.new(
      204 / 255.0 * Magick::QuantumRange,
      40 / 255.0 * Magick::QuantumRange,
      49 / 255.0 * Magick::QuantumRange,
      1.0,
    ),
    GridGem::Colors::Yellow => Magick::Pixel.new(
      229 / 255.0 * Magick::QuantumRange,
      188 / 255.0 * Magick::QuantumRange,
      49 / 255.0 * Magick::QuantumRange,
      1.0,
    ),
    GridGem::Colors::Skull => Magick::Pixel.new(
      253 / 255.0 * Magick::QuantumRange,
      253 / 255.0 * Magick::QuantumRange,
      253 / 255.0 * Magick::QuantumRange,
      1.0,
    ),
    GridGem::Colors::ExplodingSkull => Magick::Pixel.new(
      214 / 255.0 * Magick::QuantumRange,
      150 / 255.0 * Magick::QuantumRange,
      140 / 255.0 * Magick::QuantumRange,
      1.0,
    ),
  }

  def self.from_coords(rmagick_image:, coords:)
    match_counts = {}
    coords.sample(coords.length * 0.1).each do |coord|
      GridGem::ColorsToPixels.each do |color, pixel|
        if rmagick_image.pixel_color(coord.first, coord.last).fcmp(pixel, Magick::QuantumRange * 0.05)
          match_counts[color] ||= 0
          match_counts[color] +=1
          break
        end
      end
    end

    color = match_counts.to_a.sort_by(&:last).last.first

    fail('could not detect color') if color.nil?

    return GridGem.new(color: color)
  end

  attr_accessor :color

  def initialize(color:)
    self.color = color
  end

end
