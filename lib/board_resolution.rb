class BoardResolution

  attr_accessor(
    :active,
    :mana_earned,
  )

  def initialize
    self.active = false
    self.mana_earned = Hash.new(0)
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

end
