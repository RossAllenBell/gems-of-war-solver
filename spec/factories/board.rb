FactoryBot.define do
  factory :unmatchable_board, class: Board do
    grid{(0..7).map{[UnmatchableGem.new] * 8}}
  end
end
