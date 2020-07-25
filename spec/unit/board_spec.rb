require 'spec_helper'

describe Board do

  let(:board){FactoryBot.build(:unmatchable_board)}

  describe :moves do

    it 'can identify no available moves' do
      expect(board.moves.count).to eql(0)
    end

    it 'can identify the one available move' do
      board.grid[0][0] = BlueGem.new
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BrownGem.new
      board.grid[0][3] = BlueGem.new

      moves = board.moves

      expect(moves.count).to eql(1)

      move = moves.first

      swap_a = Coordinate.new(x: 0, y: 2)
      swap_b = Coordinate.new(x: 0, y: 3)
      expect([move.swap_a, move.swap_b].sort).to eql([swap_a, swap_b].sort)
    end

    it 'can identify a move that creates two matches' do
      board.grid[0][0] = BlueGem.new
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BrownGem.new
      board.grid[0][3] = BlueGem.new
      board.grid[0][4] = BrownGem.new
      board.grid[0][5] = BrownGem.new

      moves = board.moves

      expect(moves.count).to eql(1)

      move = moves.first

      swap_a = Coordinate.new(x: 0, y: 2)
      swap_b = Coordinate.new(x: 0, y: 3)
      expect([move.swap_a, move.swap_b].sort).to eql([swap_a, swap_b].sort)
    end

    it 'can identify two moves' do
      board.grid[0][0] = BlueGem.new
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BrownGem.new
      board.grid[0][3] = BlueGem.new
      board.grid[0][4] = BlueGem.new

      moves = board.moves

      expect(moves.count).to eql(2)

      expect(moves).to include(Move.new(swap_a: Coordinate.new(x: 0, y: 2), swap_b: Coordinate.new(x: 0, y: 3)))
      expect(moves).to include(Move.new(swap_a: Coordinate.new(x: 0, y: 2), swap_b: Coordinate.new(x: 0, y: 1)))
    end

    it 'does not test resolving an invalid swap' do
      board.grid[0][7] = BlueGem.new

      expect{board.moves}.not_to raise_exception
    end

    it 'reports if the move leaves the opponent with a skull match'

    it 'reports if the move leaves the oppoent with an extra turn match'

    it 'reports if the move leaves the board to be potentially jumbled'

  end

  describe :resolve! do

    it 'can resolve zero matches' do
      board_resolution = board.resolve!

      expect(board_resolution.active?).to eql(false)
      expect(board.grid.flatten.map(&:class).uniq).to eql([UnmatchableGem])
    end

    it 'can resolve a single match' do
      board.grid[0][0] = BlueGem.new
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BlueGem.new

      board_resolution = board.resolve!

      expect(board_resolution.active?).to eql(true)
      expect(board.grid[0][0].class).to eql(UnknownGem)
      expect(board.grid[0][1].class).to eql(UnknownGem)
      expect(board.grid[0][2].class).to eql(UnknownGem)
      expect(board.grid.flatten.select{|g| g.class == UnknownGem}.count).to eql(3)
      expect(board.grid.flatten.map(&:class).uniq - [UnknownGem]).to eql([UnmatchableGem])
    end

    it 'can resolve a match that causes gems above to fall' do
      board.grid[0][2] = BlueGem.new
      board.grid[0][3] = BlueGem.new
      board.grid[0][4] = BlueGem.new

      board_resolution = board.resolve!

      expect(board_resolution.active?).to eql(true)
      expect(board.grid[0][0].class).to eql(UnknownGem)
      expect(board.grid[0][1].class).to eql(UnknownGem)
      expect(board.grid[0][2].class).to eql(UnknownGem)
      expect(board.grid.flatten.select{|g| g.class == UnknownGem}.count).to eql(3)
      expect(board.grid.flatten.map(&:class).uniq - [UnknownGem]).to eql([UnmatchableGem])
    end

    it 'can resolve an exploding skull match' do
      board.grid[0][2] = SkullGem.new
      board.grid[0][3] = ExplodingSkullGem.new
      board.grid[0][4] = SkullGem.new

      board_resolution = board.resolve!

      expect(board_resolution.active?).to eql(true)
      expect(board.grid[0][0].class).to eql(UnknownGem)
      expect(board.grid[0][1].class).to eql(UnknownGem)
      expect(board.grid[0][2].class).to eql(UnknownGem)
      expect(board.grid[1][0].class).to eql(UnknownGem)
      expect(board.grid[1][1].class).to eql(UnknownGem)
      expect(board.grid[1][2].class).to eql(UnknownGem)
      expect(board.grid.flatten.select{|g| g.class == UnknownGem}.count).to eql(6)
      expect(board.grid.flatten.map(&:class).uniq - [UnknownGem]).to eql([UnmatchableGem])
    end

    it 'can resolve a chained exploding skull match' do
      board.grid[0][2] = SkullGem.new
      board.grid[0][3] = ExplodingSkullGem.new
      board.grid[0][4] = SkullGem.new
      board.grid[1][3] = ExplodingSkullGem.new

      board_resolution = board.resolve!

      expect(board_resolution.active?).to eql(true)
      expect(board.grid[0][0].class).to eql(UnknownGem)
      expect(board.grid[0][1].class).to eql(UnknownGem)
      expect(board.grid[0][2].class).to eql(UnknownGem)
      expect(board.grid[1][0].class).to eql(UnknownGem)
      expect(board.grid[1][1].class).to eql(UnknownGem)
      expect(board.grid[1][2].class).to eql(UnknownGem)
      expect(board.grid[2][0].class).to eql(UnknownGem)
      expect(board.grid[2][1].class).to eql(UnknownGem)
      expect(board.grid[2][2].class).to eql(UnknownGem)
      expect(board.grid.flatten.select{|g| g.class == UnknownGem}.count).to eql(9)
      expect(board.grid.flatten.map(&:class).uniq - [UnknownGem]).to eql([UnmatchableGem])
    end

    it 'can resolve two simultaneous matches' do
      board.grid[0][0] = BlueGem.new
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BlueGem.new
      board.grid[0][3] = BrownGem.new
      board.grid[0][4] = BrownGem.new
      board.grid[0][5] = BrownGem.new

      board_resolution = board.resolve!

      expect(board_resolution.active?).to eql(true)
      expect(board.grid[0][0].class).to eql(UnknownGem)
      expect(board.grid[0][1].class).to eql(UnknownGem)
      expect(board.grid[0][2].class).to eql(UnknownGem)
      expect(board.grid[0][3].class).to eql(UnknownGem)
      expect(board.grid[0][4].class).to eql(UnknownGem)
      expect(board.grid[0][5].class).to eql(UnknownGem)
      expect(board.grid.flatten.select{|g| g.class == UnknownGem}.count).to eql(6)
      expect(board.grid.flatten.map(&:class).uniq - [UnknownGem]).to eql([UnmatchableGem])
    end

    it 'can resolve a match that results from a prior match' do
      board.grid[0][0] = BrownGem.new
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BlueGem.new
      board.grid[0][3] = BlueGem.new
      board.grid[0][4] = BrownGem.new
      board.grid[0][5] = BrownGem.new

      board_resolution = board.resolve!

      expect(board_resolution.active?).to eql(true)
      expect(board.grid[0][0].class).to eql(UnknownGem)
      expect(board.grid[0][1].class).to eql(UnknownGem)
      expect(board.grid[0][2].class).to eql(UnknownGem)
      expect(board.grid[0][3].class).to eql(UnknownGem)
      expect(board.grid[0][4].class).to eql(UnknownGem)
      expect(board.grid[0][5].class).to eql(UnknownGem)
      expect(board.grid.flatten.select{|g| g.class == UnknownGem}.count).to eql(6)
      expect(board.grid.flatten.map(&:class).uniq - [UnknownGem]).to eql([UnmatchableGem])
    end

    it 'tracks mana earned' do
      board.grid[0][0] = BlueGem.new
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BlueGem.new

      board_resolution = board.resolve!

      expect(board_resolution.active?).to eql(true)
      expect(board_resolution.mana_earned[BlueGem]).to eql(3)
      expect(board_resolution.mana_earned[BrownGem]).to eql(0)
    end

    it 'tracks mana earned from exploding skull'

    it 'tracks if an extra turn was earned'

    it 'tracks skull damage done'

    it 'can differentiate between skull damage and an attack'

  end

  describe :test_move do

    it 'knows if the move was valid' do
      board.grid[0][0] = BlueGem.new
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BrownGem.new
      board.grid[0][3] = BlueGem.new

      board_resolution = board.test_move(
        swap_a: Coordinate.new(x: 0, y: 0),
        swap_b: Coordinate.new(x: -1, y: 0),
      )

      expect(board_resolution.active?).to eql(false)
    end

    it 'knows if the move was valid' do
      board.grid[0][0] = BlueGem.new
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BrownGem.new
      board.grid[0][3] = BlueGem.new

      board_resolution = board.test_move(
        swap_a: Coordinate.new(x: 0, y: 0),
        swap_b: Coordinate.new(x: 0, y: 1),
      )

      expect(board_resolution.active?).to eql(false)
    end

    it 'knows if the move was valid' do
      board.grid[0][0] = BlueGem.new
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BrownGem.new
      board.grid[0][3] = BlueGem.new

      board_resolution = board.test_move(
        swap_a: Coordinate.new(x: 0, y: 2),
        swap_b: Coordinate.new(x: 0, y: 3),
      )

      expect(board_resolution.active?).to eql(true)
    end

  end

end
