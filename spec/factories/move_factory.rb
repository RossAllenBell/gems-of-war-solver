FactoryBot.define do
  factory :move, class: Move do
    swap_a {Coordinate.new(x: 0, y: 0)}
    swap_b {Coordinate.new(x: 0, y: 1)}
    gem_a {BlueGem.new}
    gem_b {BrownGem.new}
    board_resolution {FactoryBot.build(:unmatchable_board).resolve!}
  end
end
