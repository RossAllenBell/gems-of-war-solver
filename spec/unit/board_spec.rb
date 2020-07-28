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

    it 'tracks the resulting mana' do
      board.grid[0][0] = BlueGem.new
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BrownGem.new
      board.grid[0][3] = BlueGem.new

      moves = board.moves

      expect(moves.count).to eql(1)

      move = moves.first

      expect(move.mana(gem_class: BlueGem)).to eql(3)
    end

    it 'reports if the move leaves the opponent with a skull match' do
      board.grid[0][0] = BlueGem.new
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BrownGem.new
      board.grid[0][3] = BlueGem.new

      moves = board.moves

      expect(moves.count).to eql(1)

      move = moves.first

      expect(move.leaves_skull_match?).to eql(false)
    end

    it 'reports if the move leaves the opponent with a skull match' do
      board.grid[0][0] = SkullGem.new
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BlueGem.new
      board.grid[0][3] = BrownGem.new
      board.grid[0][4] = BlueGem.new
      board.grid[0][5] = SkullGem.new
      board.grid[0][6] = SkullGem.new

      moves = board.moves

      expect(moves.count).to eql(1)

      move = moves.first

      expect(move.leaves_skull_match?).to eql(true)
    end

    it 'reports if the move leaves the oppoent with an extra turn match' do
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BlueGem.new
      board.grid[0][3] = BrownGem.new
      board.grid[0][4] = BlueGem.new

      moves = board.moves

      expect(moves.count).to eql(1)

      move = moves.first

      expect(move.leaves_extra_turn?).to eql(false)
    end

    it 'reports if the move leaves the oppoent with an extra turn match' do
      board.grid[0][0] = BlueGem.new
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BrownGem.new
      board.grid[0][3] = BlueGem.new
      board.grid[0][4] = GreenGem.new
      board.grid[0][5] = BrownGem.new
      board.grid[0][6] = BrownGem.new
      board.grid[1][4] = BrownGem.new

      move = board.moves.first

      expect(move.leaves_extra_turn?).to eql(true)
    end

    it 'reports if the move leaves the board to be potentially jumbled' do
      board.grid[0][0] = BlueGem.new
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BrownGem.new
      board.grid[0][3] = BlueGem.new
      board.grid[0][4] = GreenGem.new
      board.grid[0][5] = BrownGem.new
      board.grid[0][6] = BrownGem.new

      moves = board.moves

      expect(moves.count).to eql(1)

      move = moves.first

      expect(move.leaves_potential_jumble?).to eql(false)
    end

    it 'reports if the move leaves the board to be potentially jumbled' do
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BlueGem.new
      board.grid[0][3] = BrownGem.new
      board.grid[0][4] = BlueGem.new

      moves = board.moves

      expect(moves.count).to eql(1)

      move = moves.first

      expect(move.leaves_potential_jumble?).to eql(true)
    end

    it 'regression test' do
      board = Board.from_string_codes(
        <<~codes
          Gr, Sk, Pu, Gr, Bl, Sk, Br, Sk
          Bl, Br, Re, Sk, Ye, Gr, Pu, Bl
          Bl, Re, Br, Sk, Bl, Re, ES, Ye
          Br, Sk, Gr, Re, Re, Sk, Br, Gr
          Sk, Gr, Ye, Re, Sk, Gr, Bl, Re
          Br, Pu, Gr, Pu, Gr, Pu, ES, Bl
          Gr, Sk, Sk, Gr, Re, Ye, Re, Br
          Bl, Pu, Re, Ye, Br, Re, Gr, Sk
        codes
      )

      moves = board.moves

      move_3_4_to_3_5 = moves.detect do |move|
        [move.swap_a, move.swap_b].sort == [Coordinate.new(x: 3, y: 5), Coordinate.new(x: 3, y: 6)].sort
      end

      expect(move_3_4_to_3_5).to be
      expect(move_3_4_to_3_5.leaves_skull_match?).to eql(true) # from a chain reaction
    end

  end

  describe :resolve! do

    it 'can resolve zero matches' do
      board_resolution = board.resolve!

      expect(board_resolution.active?).to eql(false)
      expect(board.grid.flatten.map(&:class).uniq).to eql([UnmatchableGem])
    end

    it 'tracks when a resolution was active' do
      board.grid[0][0] = BlueGem.new
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BlueGem.new

      board_resolution = board.resolve!

      expect(board_resolution.active?).to eql(true)
    end

    it 'can resolve a single match' do
      board.grid[0][0] = BlueGem.new
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BlueGem.new

      board_resolution = board.resolve!

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

      expect(board_resolution.mana(gem_class: BlueGem)).to eql(3)
      expect(board_resolution.mana(gem_class: BrownGem)).to eql(0)
    end

    it 'tracks mana earned' do
      board.grid[0][0] = BlueGem.new
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BlueGem.new
      board.grid[0][3] = BlueGem.new

      board_resolution = board.resolve!

      expect(board_resolution.mana(gem_class: BlueGem)).to eql(4)
      expect(board_resolution.mana(gem_class: BrownGem)).to eql(0)
    end

    it 'tracks half mana earned from exploding skull' do
      board.grid[0][2] = SkullGem.new
      board.grid[0][3] = ExplodingSkullGem.new
      board.grid[0][4] = SkullGem.new
      board.grid[1][3] = BlueGem.new

      board_resolution = board.resolve!

      expect(board_resolution.mana(gem_class: BlueGem)).to eql(0)
    end

    it 'tracks mana earned from exploding skull' do
      board.grid[0][2] = SkullGem.new
      board.grid[0][3] = ExplodingSkullGem.new
      board.grid[0][4] = SkullGem.new
      board.grid[1][3] = BlueGem.new
      board.grid[1][4] = BlueGem.new

      board_resolution = board.resolve!

      expect(board_resolution.mana(gem_class: BlueGem)).to eql(1)
    end

    it 'tracks mana earned from exploding skull' do
      board.grid[0][2] = SkullGem.new
      board.grid[0][3] = SkullGem.new
      board.grid[0][4] = ExplodingSkullGem.new
      board.grid[0][5] = BlueGem.new
      board.grid[1][3] = BlueGem.new
      board.grid[1][4] = BlueGem.new

      board_resolution = board.resolve!

      expect(board_resolution.mana(gem_class: BlueGem)).to eql(1)
    end

    it 'tracks if an extra turn was earned' do
      board.grid[0][0] = BlueGem.new
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BlueGem.new

      board_resolution = board.resolve!

      expect(board_resolution.extra_turn?).to eql(false)
    end

    it 'tracks if an extra turn was earned' do
      board.grid[0][0] = BlueGem.new
      board.grid[0][1] = BlueGem.new
      board.grid[0][2] = BlueGem.new
      board.grid[0][3] = BlueGem.new

      board_resolution = board.resolve!

      expect(board_resolution.extra_turn?).to eql(true)
    end

    it 'tracks skull damage done' do
      board.grid[0][0] = SkullGem.new
      board.grid[0][1] = SkullGem.new
      board.grid[0][2] = SkullGem.new

      board_resolution = board.resolve!

      expect(board_resolution.skull_damage).to eql(0)
    end

    it 'tracks skull damage done' do
      board.grid[0][0] = SkullGem.new
      board.grid[0][1] = ExplodingSkullGem.new
      board.grid[0][2] = SkullGem.new

      board_resolution = board.resolve!

      expect(board_resolution.skull_damage).to eql(0)
    end

    it 'tracks skull damage done' do
      board.grid[0][0] = SkullGem.new
      board.grid[0][1] = ExplodingSkullGem.new
      board.grid[0][2] = SkullGem.new
      board.grid[1][0] = SkullGem.new

      board_resolution = board.resolve!

      expect(board_resolution.skull_damage).to eql(1)
    end

    it 'tracks number of attacks' do
      board.grid[0][0] = BlueGem.new
      board.grid[0][1] = SkullGem.new
      board.grid[0][2] = SkullGem.new

      board_resolution = board.resolve!

      expect(board_resolution.attacks).to eql(0)
    end

    it 'tracks number of attacks' do
      board.grid[0][0] = SkullGem.new
      board.grid[0][1] = SkullGem.new
      board.grid[0][2] = SkullGem.new

      board_resolution = board.resolve!

      expect(board_resolution.attacks).to eql(1)
    end

    it 'tracks number of attacks' do
      board.grid[0][0] = SkullGem.new
      board.grid[0][1] = SkullGem.new
      board.grid[0][2] = SkullGem.new
      board.grid[0][4] = SkullGem.new

      board_resolution = board.resolve!

      expect(board_resolution.attacks).to eql(1)
    end

    it 'tracks number of attacks' do
      board.grid[0][0] = SkullGem.new
      board.grid[0][1] = SkullGem.new
      board.grid[0][2] = SkullGem.new
      board.grid[1][0] = SkullGem.new
      board.grid[1][1] = SkullGem.new
      board.grid[1][2] = SkullGem.new

      board_resolution = board.resolve!

      expect(board_resolution.attacks).to eql(2)
    end

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
