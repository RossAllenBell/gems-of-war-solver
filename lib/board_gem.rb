class BoardGem

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

end
