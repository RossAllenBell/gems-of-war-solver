class BoardResolution

  attr_accessor(
    :active,
    :mana_earned,
    :extra_turn,
  )

  def initialize
    self.active = false
    self.mana_earned = Hash.new(0)
    self.extra_turn = false
  end

  def was_active!
    self.active = true
  end

  def active?
    return self.active
  end

  def add_mana(board_gem:, amount: 1)
    self.mana_earned[board_gem.class] += amount
  end

  def mana(gem_class:)
    self.mana_earned[gem_class].to_i
  end

  def extra_turn!
    self.extra_turn = true
  end

  def extra_turn?
    return self.extra_turn
  end

end
