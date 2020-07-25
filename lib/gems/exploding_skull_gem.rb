class ExplodingSkullGem < BoardGem

  def matches?(other)
    return super || other.class == SkullGem
  end

  def string_code
    'ES'
  end

end
