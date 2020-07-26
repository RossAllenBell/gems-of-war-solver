class Game

  @debug = false

  attr_accessor(
    :board,
  )

  def initialize(board: nil)
    self.board = board
  end

  def update(screen:)
    self.board = Board.new
    (0..Board::Width - 1).each do |x|
      (0..Board::Height - 1).each do |y|
        self.board.grid[x][y] = screen.gem_at(x: x, y: y).board_gem
      end
    end
  end

  def moves
    return self.board.moves
  end

  def print_state
    self.board.print_state

    puts ''
    puts 'Moves:'
    puts ''

    self.moves.sort.each do |move|
      puts "  #{move}"
      puts '    extra turn' if move.extra_turn?
      puts '    follow up extra turn' if move.follow_up_extra_turn?
      puts '    leaves extra turn' if move.leaves_extra_turn? && !move.extra_turn?
      puts '    leaves skull match' if move.leaves_skull_match? && !move.extra_turn?
      puts '    potential jumble' if move.leaves_potential_jumble?
      puts '    attack' if move.attacks > 0
    end
  end

  def self.set_debug(value)
    @debug = value
  end

  def self.debug?
    return @debug
  end

end
