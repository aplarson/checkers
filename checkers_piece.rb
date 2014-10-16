class Piece
  attr_reader :color, :board, :king
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
  	if slideable?(pos_to)
      board[self.pos] = nil
      board[pos_to] = self
  	  self.pos = pos_to
      promote if promotable?
  	else
  		raise "Can't move there"
  	end
  end

  def perform_jump(pos_to)
  	if jumpable?(pos_to)
      board[pos_jumped(self.pos, pos_to)] = nil
      board[self.pos] = nil
      board[pos_to] = self
      self.pos = pos_to
      promote if promotable?
    else
      raise "Can't move there"
    end
  end
  
  private
  
  def promotable?
  	color == :white ? pos[0] == 0 : pos[0] == 7
  end

  def promote
  	@king = true
  end
  
  def jumpable?(pos_to)
    move_diffs.any? do |diff|
      board[pos_to].nil? &&
      pos_to == [pos[0] + (2 * diff[0]), pos[1] + (2 * diff[1])] &&
      !board[pos_jumped(self.pos, pos_to)].nil? &&
      board[pos_jumped(self.pos, pos_to)].color == enemy_color
    end
  end
  
  def pos_jumped(pos_from, pos_to)
    [(pos_from[0] + pos_to[0]) / 2, (pos_from[1] + pos_to[1]) / 2]
  end
  
  def slideable?(pos_to)
    board[pos_to].nil? && 
      move_diffs.any? { |diff| pos_to == [pos[0] + diff[0], pos[1] + diff[1]]}
  end
  
  def enemy_color
    color == :white ? :red : :white
  end
end
