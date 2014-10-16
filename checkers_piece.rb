require_relative 'checker_board'

class Piece
  attr_reader :color, :board
  attr_accessor :pos

  def initialize(pos, color, board)
  	@pos = pos
  	@color = color
  	@board = board
  	@king = false
  end

  def move_diffs
  	if @king
  		[[1, 1], [1, -1], [-1, -1], [-1, 1]]
  	else
  		color == :white ? [[-1, 1], [-1, -1]] : [[1, -1], [1, 1]]
  	end
  end

  def perform_slide(pos_to)
  	if move_diffs.any? { |diff| pos_to == [pos[0] + diff[0], pos[1] + diff[1]]}
  	  self.pos = pos_to
  	else
  		raise "Can't move there"
  	end
  end

  def perform_jump(pos_to)
  	if jumpable?(pos_to)
      self.pos = pos_to
    end
  end

  def promote?
  	color == :white ? pos[0] == 0 : pos[0] == 7
  end

  def promote
  	@king = true
  end

  def display
  	[color, pos].to_s
  end
  
  def jumpable?(pos)
  	jumped_pos = 
  	move_diffs.any? { |diff| pos_to == [pos[0] + (2 * diff[0]), pos[1] + (2 * diff[1])] } && board[pos].nil? && 
  	  board[pos].color != self.color
  end

end