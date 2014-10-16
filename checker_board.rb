require_relative 'checkers_piece'
require 'colorize'

class Board
  attr_accessor :grid
  
  def initialize(new_game = true)
 	  @grid = Array.new(8) { Array.new(8) {nil} }
    if new_game
      populate
    end
  end

  def populate
  	even_row = [nil, Piece, nil, Piece, nil, Piece, nil, Piece]
  	odd_row = [Piece, nil, Piece, nil, Piece, nil, Piece, nil]
    starting_rows = { :red => [0, 1, 2], :white => [5, 6, 7] }
    starting_rows.each_pair do |color, rows|
      rows.each do |row|
        if row % 2 == 0
	        even_row.each_with_index do |klass, col| 
            populate_square(klass, [row, col], color)
          end
        else
          odd_row.each_with_index do |klass, col| 
            populate_square(klass, [row, col], color)
          end
        end
      end
    end
  end

  def display
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |square, col_idx| 
        print make_square(row_idx, col_idx, display_square(square))
      end
      print "\n"
    end
  end
  
  def display_square(square)
    return '   ' if square.nil?
    square.display
  end
  
  def make_square(row, col, val)
    return val.colorize(:background => :black) if (row + col) % 2 == 1
    val.colorize(:background => :red)
  end
  
  def [](pos)
	row, col = pos
	@grid[row][col]
  end

  def []=(pos, val)
	row, col = pos
	@grid[row][col] = val
  end
  
  def populate_square(klass, pos, color)
    self[pos] = klass.new(pos, color, self) unless klass.nil?
  end
  
  def pieces
    @grid.flatten.select { |square| !square.nil? }
  end
  
  def over?
    pieces.all? { |piece| piece.color == :red } || 
      pieces.all? { |piece| piece.color == :white}
  end
  
  def winner
    puts "The #{pieces[0].color} player wins!"
  end
  
  def each(&prc)
    grid.each_with_index do |row, r_idx|
      row.each_index do |square|
        prc.call([r_idx, square])
      end
    end
  end
  
  def dup
    dup_board = Board.new(false)
    pieces.each do |piece|
      dup_board[piece.pos] = piece.dup(dup_board)
    end
    dup_board
  end
end
