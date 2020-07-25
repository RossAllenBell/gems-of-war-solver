class Coordinate

  attr_accessor(
    :x,
    :y,
  )

  def initialize(x:, y:)
    self.x = x
    self.y = y
  end

  def ==(other)
    return self.x == other.x && self.y == other.y
  end

  def ===(other)
    return self == other
  end

  def eql?(other)
    return self == other
  end

  def <=>(other)
    return [self.x, self.y] <=> [other.x, other.y]
  end

  def hash
    return [self.x, self.y].hash
  end

  def +(other)
    return Coordinate.new(x: self.x + other.x, y: self.y + other.y)
  end

  def -(other)
    return Coordinate.new(x: self.x - other.x, y: self.y - other.y)
  end

  def distance_from(x: nil, y: nil, coordinate: nil)
    compare_x = x || coordinate.x
    compare_y = y || coordinate.y
    Math.sqrt(((compare_x - self.x) ** 2) + ((compare_y - self.y) ** 2))
  end

  def cardinal_steps
    return [
      Coordinate.new(x: self.x, y: self.y - 1),
      Coordinate.new(x: self.x + 1, y: self.y),
      Coordinate.new(x: self.x, y: self.y + 1),
      Coordinate.new(x: self.x - 1, y: self.y),
    ]
  end

  def all_eight_steps
    return [
      Coordinate.new(x: self.x,     y: self.y - 1),
      Coordinate.new(x: self.x + 1, y: self.y - 1),
      Coordinate.new(x: self.x + 1, y: self.y),
      Coordinate.new(x: self.x + 1, y: self.y + 1),
      Coordinate.new(x: self.x,     y: self.y + 1),
      Coordinate.new(x: self.x - 1, y: self.y + 1),
      Coordinate.new(x: self.x - 1, y: self.y),
      Coordinate.new(x: self.x - 1, y: self.y - 1),
    ]
  end

end
