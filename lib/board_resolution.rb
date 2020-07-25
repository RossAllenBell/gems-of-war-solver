class BoardResolution

  attr_accessor(
    :active
  )

  def initialize(active:)
    self.active = active
  end

  def active?
    return self.active
  end

end
