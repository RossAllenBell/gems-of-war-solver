class BoardGem

  def self.from_code(code:)
    ObjectSpace.each_object(Class).select { |klass| klass < self }.detect do |klass|
      klass.new.string_code == code
    end.new
  end

  def dup
    return self.class.new
  end

  def moveable?
    return true
  end

  def matchable?
    return false unless self.moveable?
    return true
  end

  def matches?(other)
    return false unless self.matchable?
    self.class == other.class
  end

  def is_mana?
    return false
  end

  def skull_damage
    0
  end

end
