class UnmatchableGem < BoardGem

  def moveable?
    return false
  end

  def matchable?
    return false
  end

  def string_code
    'Um'
  end

end
