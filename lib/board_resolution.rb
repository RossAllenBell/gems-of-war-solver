class BoardResolution

  attr_accessor(
    :board,
    :active,
    :mana_earned,
    :extra_turn,
    :skull_damage,
    :attacks,
  )

  def initialize(board: nil)
    self.board = board
    self.active = false
    self.mana_earned = Hash.new(0)
    self.extra_turn = false
    self.skull_damage = 0
    self.attacks = 0
  end

  def was_active!
    self.active = true
  end

  def active?
    return self.active
  end

  def add_mana(board_gem:, amount: 1)
    if board_gem.is_mana?
      self.mana_earned[board_gem.class] += amount
    end
  end

  def mana(gem_class:)
    self.mana_earned[gem_class].to_i
  end

  def total_mana_gained
    self.mana_earned.to_a.select do |gem_class, raw_mana|
      gem_class.new.is_mana?
    end.map(&:last).map(&:to_i).sum
  end

  def mana_types
    self.mana_earned.to_a.select do |gem_class, raw_mana|
      gem_class.new.is_mana? && raw_mana >= 1
    end.map(&:first).map(&:name)
  end

  def extra_turn!
    self.extra_turn = true
  end

  def extra_turn?
    return self.extra_turn
  end

  def add_skull_damage(board_gem:)
    if board_gem.skull_damage > 0
      self.skull_damage += board_gem.skull_damage
    end
  end

  def add_attack
    self.attacks += 1
  end

end
