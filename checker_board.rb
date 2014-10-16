require_relative 'checkers_piece'
require 'colorize'

class Board
  attr_accessor :grid
  def initialize
 	  @grid = Array.new(8) { Array.new(8) {nil} }
    #populate
  end

  def populate
  	even_row = [nil, Piece, nil, Piece, nil, Piece, nil, Piece]
  	odd_row = [Piece, nil, Piece, nil, Piece, nil, Piece, nil]
    [0, 2].each do |row|
	    even_row.each_with_index do |klass, col| 
        @grid[row][col] = klass.new([row, col], :red, self) unless klass.nil?
      end
    end
    odd_row.each_with_index do |klass, col| 
      @grid[1][col] = klass.new([1, col], :red, self) unless klass.nil?
    end
    even_row.each_with_index do |klass, col| 
      @grid[6][col] = klass.new([4, col], :white, self) unless klass.nil?
    end
    [5, 7].each do |row|
      odd_row.each_with_index do |klass, col| 
        @grid[row][col] = klass.new([row, col], :white, self) unless klass.nil?
      end
    end
  end

  def display
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |square, col_idx| 
        print background_color(row_idx, col_idx, display_square(square))
      end
      print "\n"
    end
  end
  
  def display_square(square)
    return '   ' if square.nil?
    square.color.to_s[0..2]
  end
  
  def background_color(row, col, val)
    return val.colorize(:background => :green) if (row + col) % 2 == 1
    val
  end
  
  def [](pos)
	row, col = pos
	@grid[row][col]
  end

  def []=(pos, val)
	row, col = pos
	@grid[row][col] = val
  end
end

a = Board.new
p = Piece.new([6, 1], :red, a)
a[[6, 1]] = p
p.perform_slide([7, 0])
p p.king
a[[6, 1]] = Piece.new([6, 1], :white, a)
a.display
p.perform_jump([5, 2])
puts " "
a.display