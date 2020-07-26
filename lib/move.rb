class Move

  attr_accessor(
    :swap_a,
    :swap_b,
    :gem_a,
    :gem_b,
    :board_resolution,
  )

  def initialize(swap_a: nil, swap_b: nil, gem_a: nil, gem_b: nil, board_resolution: nil)
    self.swap_a = swap_a
    self.swap_b = swap_b
    self.gem_a = gem_a
    self.gem_b = gem_b
    self.board_resolution = board_resolution
  end

  def ==(other)
    return [other.swap_a, other.swap_b].sort == [self.swap_a, self.swap_b].sort
  end

  def ===(other)
    return self == other
  end

  def eql?(other)
    return self == other
  end

  def <=>(other)
    return [self.swap_a, self.swap_b].sort <=> [other.swap_a, other.swap_b].sort
  end

  def hash
    return [self.swap_a, self.swap_b].sort.hash
  end

  def to_s
    return "[#{self.swap_a.x},#{self.swap_a.y}] #{self.gem_a.string_code} -> [#{self.swap_b.x},#{self.swap_b.y}] #{self.gem_b.string_code}"
  end

  def mana(gem_class:)
    self.board_resolution.mana(gem_class: gem_class)
  end

  def leaves_skull_match?
    return self.board_resolution.board.moves.any? do |move|
      move.attacks > 0
    end
  end

  def leaves_extra_turn?
    return self.board_resolution.board.moves.any?(&:extra_turn?)
  end

  def leaves_potential_jumble?
    return self.board_resolution.board.moves.empty?
  end

  def extra_turn?
    return self.board_resolution.extra_turn
  end

  def skull_damage
    return self.board_resolution.skull_damage
  end

  def attacks
    return self.board_resolution.attacks
  end

end
