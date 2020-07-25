class SkullGem < BoardGem

  def matches?(other)
    return super || other.class == ExplodingSkullGem
  end

  def string_code
    'Sk'
  end

end
