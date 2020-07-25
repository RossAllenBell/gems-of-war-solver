class Board

  Width = 8
  Height = 8

  attr_accessor(
    :grid
  )

  def initialize(grid: nil)
    self.grid = grid || (0..Board::Width - 1).map{[nil] * Board::Height}
  end

  def dup
    new_board = Board.new

    new_board.grid = self.grid.map do |columns|
      columns.map(&:dup)
    end

    return new_board
  end

  def moves
    collected_moves = []

    self.grid.each_with_index do |column_gems, x|
      column_gems.each_with_index do |board_gem, y|
        if board_gem.moveable?
          swap_a = Coordinate.new(x: x, y: y)

          swap_a.cardinal_steps.each do |potential_swap|
            if self.test_move(swap_a: swap_a, swap_b: potential_swap)
              collected_moves << Move.new(
                swap_a: swap_a,
                swap_b: potential_swap,
                gem_a: self.grid[swap_a.x][swap_a.y],
                gem_b: self.grid[potential_swap.x][potential_swap.y],
              )
            end
          end
        end
      end
    end

    return collected_moves.uniq
  end

  def test_move(swap_a:, swap_b:)
    return false unless is_valid_coordinate?(coordinate: swap_a)
    return false unless is_valid_coordinate?(coordinate: swap_b)

    test_board = self.dup
    fail('unresolved board') if test_board.resolve!
    temp = test_board.grid[swap_a.x][swap_a.y]
    test_board.grid[swap_a.x][swap_a.y] = test_board.grid[swap_b.x][swap_b.y]
    test_board.grid[swap_b.x][swap_b.y] = temp
    return test_board.resolve!
  end

  def resolve!
    gems_cleared = false
    gems_cleared_this_step = true

    while gems_cleared_this_step
      matched_coordinates = []

      self.grid.each_with_index do |column_gems, x|
        column_gems.each_with_index do |board_gem, y|
          if board_gem.matchable?
            coordinate = Coordinate.new(x: x, y: y)
            matching_threes = self.find_matching_threes_from(coordinate: coordinate)
            if matching_threes.count >= 3
              matched_coordinates += matching_threes
              matched_coordinates.uniq!
            end
          end
        end
      end

      gems_cleared ||= matched_coordinates.any?
      gems_cleared_this_step = matched_coordinates.any?

      exploding_skull_coords = matched_coordinates.map do |coord|
        board_gem = self.grid[coord.x][coord.y]
        coord if board_gem.class == ExplodingSkullGem
      end.compact

      i = 0
      while i < exploding_skull_coords.count
        coord = exploding_skull_coords[i]
        exploding_skull_coords += coord.all_eight_steps.map do |other_coord|
          if self.is_valid_coordinate?(coordinate: other_coord)
            other_coord if self.grid[other_coord.x][other_coord.y].class == ExplodingSkullGem
          end
        end.compact
        exploding_skull_coords.uniq!
        i += 1
      end

      matched_coordinates.each do |coord|
        self.grid[coord.x][coord.y] = nil
      end

      exploding_skull_coords.each do |exploding_skull_coord|
        if self.is_valid_coordinate?(coordinate: exploding_skull_coord)
          self.grid[exploding_skull_coord.x][exploding_skull_coord.y] = nil
          exploding_skull_coord.all_eight_steps.each do |other_coord|
            if self.is_valid_coordinate?(coordinate: other_coord)
              self.grid[other_coord.x][other_coord.y] = nil
            end
          end
        end
      end

      self.grid.map(&:compact!)
      self.grid.each_with_index do |gem_column, column|
        self.grid[column] = (0..Board::Height - self.grid[column].count - 1).map{UnknownGem.new} + self.grid[column]
      end
    end

    return BoardResolution.new(
      active: gems_cleared,
    end
  end

  def find_matching_threes_from(coordinate:)
    contiguous_coordinates = [coordinate]
    start_gem = self.grid[coordinate.x][coordinate.y]

    coordinate.cardinal_steps.each do |possible_coordinate|
      if self.is_valid_coordinate?(coordinate: possible_coordinate)
        possible_gem = self.grid[possible_coordinate.x][possible_coordinate.y]
        if start_gem.matches?(possible_gem)
          direction = possible_coordinate - coordinate
          third_gem_coordinate = possible_coordinate + direction
          if self.is_valid_coordinate?(coordinate: third_gem_coordinate)
            third_gem = self.grid[third_gem_coordinate.x][third_gem_coordinate.y]
            if start_gem.matches?(third_gem)
              contiguous_coordinates << possible_coordinate
              contiguous_coordinates << third_gem_coordinate
            end
          end
        end
      end
    end

    return [] unless contiguous_coordinates.count >= 3
    return contiguous_coordinates
  end

  def is_valid_coordinate?(coordinate:)
    return false if coordinate.y < 0
    return false if coordinate.x >= Board::Width
    return false if coordinate.y >= Board::Height
    return false if coordinate.x < 0
    return true
  end

  def print_state
    puts '   0   1   2   3   4   5   6   7'
    puts '  --------------------------------'
    (0..Board::Height - 1).each_with_index do |row|
      print "#{row}| "
      (0..Board::Width - 1).each_with_index do |column|
        print '%2s' % self.grid[column][row]&.string_code
        if column == Board::Width - 1
          puts ''
        else
          print ', '
        end
      end
    end
  end

end
