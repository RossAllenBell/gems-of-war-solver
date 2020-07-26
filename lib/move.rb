class Move
  extend Memoist

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
    self_extra_turn = self.extra_turn? ? 0 : 1
    self_leaves_extra_turn_after_extra_turn = (self.follow_up_extra_turn?) ? 0 : 1
    self_leaves_extra_turn = self.leaves_extra_turn? ? 1 : 0
    self_leaves_skull_match = self.leaves_skull_match? ? 1 : 0
    self_leaves_potential_jumble = self.leaves_potential_jumble? ? 1 : 0
    self_any_attacks = self.attacks > 0 ? 0 : 1
    self_mana_gained = -1 * self.total_mana_gained

    other_extra_turn = other.extra_turn? ? 0 : 1
    other_leaves_extra_turn_after_extra_turn = (other.follow_up_extra_turn?) ? 0 : 1
    other_leaves_extra_turn = other.leaves_extra_turn? ? 1 : 0
    other_leaves_skull_match = other.leaves_skull_match? ? 1 : 0
    other_leaves_potential_jumble = other.leaves_potential_jumble? ? 1 : 0
    other_any_attacks = other.attacks > 0 ? 0 : 1
    other_mana_gained = -1 * other.total_mana_gained

    return [
      self_extra_turn,
      self_leaves_extra_turn_after_extra_turn,
      self_leaves_extra_turn,
      self_leaves_skull_match,
      self_leaves_potential_jumble,
      self_any_attacks,
      self_mana_gained,
      self.mana_types,
      [self.swap_a, self.swap_b].sort,
    ] <=> [
      other_extra_turn,
      other_leaves_extra_turn_after_extra_turn,
      other_leaves_extra_turn,
      other_leaves_skull_match,
      other_leaves_potential_jumble,
      other_any_attacks,
      other_mana_gained,
      other.mana_types,
      [other.swap_a, other.swap_b].sort,
    ]
  end

  def hash
    return [self.swap_a, self.swap_b].sort.hash
  end

  def to_s
    mana_string = self.board_resolution.mana_earned.to_a.select do |gem_class, raw_mana|
      raw_mana.to_i >= 1
    end.sort_by do |gem_class, raw_mana|
      [-raw_mana, gem_class.new.string_code]
    end.map do |gem_class, raw_mana|
      "#{gem_class.new.string_code} (#{raw_mana.to_i})"
    end.join(', ')

    return "[#{self.swap_a.x},#{self.swap_a.y}] #{self.gem_a.string_code} -> [#{self.swap_b.x},#{self.swap_b.y}] #{self.gem_b.string_code} | #{mana_string}"
  end

  def mana(gem_class:)
    self.board_resolution.mana(gem_class: gem_class)
  end

  def total_mana_gained
    self.board_resolution.total_mana_gained
  end

  def mana_types
    self.board_resolution.mana_types
  end

  def leaves_skull_match?
    return self.board_resolution.board.moves.any? do |move|
      move.attacks > 0
    end
  end
  memoize :leaves_skull_match?

  def leaves_extra_turn?
    return self.board_resolution.board.moves.any?(&:extra_turn?)
  end
  memoize :leaves_extra_turn?

  def leaves_potential_jumble?
    return self.board_resolution.board.moves.empty?
  end
  memoize :leaves_potential_jumble?

  def extra_turn?
    return self.board_resolution.extra_turn
  end
  memoize :extra_turn?

  def follow_up_extra_turn?
    return self.extra_turn? && self.leaves_extra_turn?
  end
  memoize :follow_up_extra_turn?

  def skull_damage
    return self.board_resolution.skull_damage
  end

  def attacks
    return self.board_resolution.attacks
  end

end
