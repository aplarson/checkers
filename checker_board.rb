require_relative 'checkers_piece'

class Board
  attr_accessor :grid
  def initialize
 	@grid = Array.new(8) { Array.new(8) {nil} }
  end

  def populate
  	even_row = [nil, Piece.new([0, 1], :red, self), nil, Piece.new([0, 3], :red, self), 
  	            nil, Piece.new([0, 5], :red, self), nil, Piece.new([0, 7], :red, self)]
  	#odd_row = [Piece, nil, Piece, nil, Piece, nil, Piece, nil]
	@grid[1] = even_row
  end

  def display
    @grid.each { |row| p row }
  end

  def [](pos)
	row, col = pos
	@grid[row, col]
  end

  def []=(pos, val)
	row, col = pos
	@grid[row][col] = val
  end
  

end

b = Board.new
b.populate
b.display