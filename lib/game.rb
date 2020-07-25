class Game

  Debug = true

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
    end
  end

end
