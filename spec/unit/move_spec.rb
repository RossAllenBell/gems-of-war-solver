require 'spec_helper'

describe Move do

  it 'sorting prefers moves closer to the top' do
    move = [
      FactoryBot.build(:move, swap_a: Coordinate.new(x: 0, y: 1), swap_b: Coordinate.new(x: 0, y: 1)),
      FactoryBot.build(:move, swap_a: Coordinate.new(x: 1, y: 0), swap_b: Coordinate.new(x: 1, y: 0)),
      FactoryBot.build(:move, swap_a: Coordinate.new(x: 2, y: 2), swap_b: Coordinate.new(x: 2, y: 2)),
    ].sort.first

    expect(move.swap_a.y).to eql(0)
  end

  it 'sorting prefers moves closer to the edge' do
    move = [
      FactoryBot.build(:move, swap_a: Coordinate.new(x: 1, y: 0), swap_b: Coordinate.new(x: 1, y: 0)),
      FactoryBot.build(:move, swap_a: Coordinate.new(x: 0, y: 0), swap_b: Coordinate.new(x: 0, y: 0)),
      FactoryBot.build(:move, swap_a: Coordinate.new(x: 2, y: 0), swap_b: Coordinate.new(x: 2, y: 0)),
    ].sort.first

    expect(move.swap_a.x).to eql(0)
  end

  it 'sorting prefers moves closer to the edge' do
    move = [
      FactoryBot.build(:move, swap_a: Coordinate.new(x: 1, y: 0), swap_b: Coordinate.new(x: 1, y: 0)),
      FactoryBot.build(:move, swap_a: Coordinate.new(x: 7, y: 0), swap_b: Coordinate.new(x: 7, y: 0)),
      FactoryBot.build(:move, swap_a: Coordinate.new(x: 2, y: 0), swap_b: Coordinate.new(x: 2, y: 0)),
    ].sort.first

    expect(move.swap_a.x).to eql(7)
  end

  it 'sorting prefers moves closer to the left' do
    move = [
      FactoryBot.build(:move, swap_a: Coordinate.new(x: 6, y: 0), swap_b: Coordinate.new(x: 6, y: 0)),
      FactoryBot.build(:move, swap_a: Coordinate.new(x: 1, y: 0), swap_b: Coordinate.new(x: 1, y: 0)),
      FactoryBot.build(:move, swap_a: Coordinate.new(x: 2, y: 0), swap_b: Coordinate.new(x: 2, y: 0)),
    ].sort.first

    expect(move.swap_a.x).to eql(1)
  end

  it 'sorting prefers more mana gained' do
    move = [
      FactoryBot.build(:move, swap_a: Coordinate.new(x: 0, y: 0), swap_b: Coordinate.new(x: 0, y: 0)),
      FactoryBot.build(:move, swap_a: Coordinate.new(x: 0, y: 0), swap_b: Coordinate.new(x: 0, y: 0)).tap{|m| m.board_resolution.add_mana(board_gem: BlueGem.new)},
      FactoryBot.build(:move, swap_a: Coordinate.new(x: 0, y: 0), swap_b: Coordinate.new(x: 0, y: 0)),
    ].sort.first

    expect(move.mana(gem_class: BlueGem)).to eql(1)
  end

  it 'sorts based on mana type' do
    move = [
      FactoryBot.build(:move, swap_a: Coordinate.new(x: 0, y: 0), swap_b: Coordinate.new(x: 0, y: 0)).tap{|m| m.board_resolution.add_mana(board_gem: BrownGem.new)},
      FactoryBot.build(:move, swap_a: Coordinate.new(x: 0, y: 0), swap_b: Coordinate.new(x: 0, y: 0)).tap{|m| m.board_resolution.add_mana(board_gem: BlueGem.new)},
      FactoryBot.build(:move, swap_a: Coordinate.new(x: 0, y: 0), swap_b: Coordinate.new(x: 0, y: 0)),
    ].sort.first

    expect(move.mana(gem_class: BlueGem)).to eql(1)
  end

end
