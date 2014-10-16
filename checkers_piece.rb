# encoding: utf-8
require 'debugger'

class Piece
  attr_reader :color, :board, :king
  attr_accessor :pos

  def initialize(pos, color, board, king = false)
  	@pos = pos
  	@color = color
  	@board = board
  	@king = king
  end
  
  def perform_moves!(move_sequence)
    if slideable?(move_sequence[0])
      perform_slide(move_sequence[0])
    else
      move_sequence.each do |move|
        perform_jump(move)
      end
    end
  end

  def perform_slide(pos_to)
  	if slideable?(pos_to)
      board[self.pos] = nil
      board[pos_to] = self
  	  self.pos = pos_to
  	else
  		raise IllegalMoveError
  	end
  end

  def perform_jump(pos_to)
  	if jumpable?(pos_to)
      board[pos_jumped(self.pos, pos_to)] = nil
      board[self.pos] = nil
      board[pos_to] = self
      self.pos = pos_to
    else
      raise IllegalMoveError
    end
  end
  
  def valid_move_seq?(move_seq)
    dup_board = board.dup
    jumping = true if jump?(move_seq[0])
    begin
      dup_mover = dup_board[pos]
    raise IllegalMoveError if !jumping && friendly_jumps?
      dup_mover.perform_moves!(move_seq)
    raise IllegalMoveError if jumping && dup_mover.can_jump?
    rescue IllegalMoveError
      puts "You can't move there"
      return false
    end
    true
  end
  
  def perform_moves(move_seq)
    raise IllegalMoveError unless valid_move_seq?(move_seq)
    perform_moves!(move_seq)
    promote if promotable?
  end
  
  def display
    if @king
      " ♔ ".colorize(:color => self.color)
    else
      " ⚙ ".colorize(:color => self.color)
    end
  end
  
  def dup(dup_board)
    Piece.new(pos, color, dup_board, king)
  end
  
  def jumpable?(pos_to)
    move_diffs.any? do |diff|
      on_board?(pos_to) &&
        board[pos_to].nil? &&
        pos_to == [pos[0] + (2 * diff[0]), pos[1] + (2 * diff[1])] &&
        !board[pos_jumped(self.pos, pos_to)].nil? &&
        board[pos_jumped(self.pos, pos_to)].color == enemy_color
    end
  end
  
  def jump?(move)
    jumpable?(move)
  end
  
  def can_jump?
    board.each do |square| 
      return true if jumpable?(square)
    end
    false
  end
  
  def can_slide?
    board.each do |square| 
      return true if slideable?(square)
    end
    false
  end
  
  def slideable?(pos_to)
    on_board?(pos_to) &&
      board[pos_to].nil? && 
      move_diffs.any? { |diff| pos_to == [pos[0] + diff[0], pos[1] + diff[1]]}
  end
  
  private
  
  def enemy_color
    color == :white ? :red : :white
  end
  
  def friendly_jumps?
    friendlies = board.pieces.select { |piece| piece.color == self.color }
    board.each do |square| 
      return true if friendlies.any? { |piece| piece.jumpable?(square) }
    end
    false
  end
  
  def move_diffs
  	if @king
  		WHITE_MOVES + RED_MOVES
  	else
  		color == :white ? WHITE_MOVES : RED_MOVES
  	end
  end
  
  def pos_jumped(pos_from, pos_to)
    [(pos_from[0] + pos_to[0]) / 2, (pos_from[1] + pos_to[1]) / 2]
  end
  
  def promotable?
  	color == :white ? pos[0] == 0 : pos[0] == 7
  end

  def promote
  	@king = true
  end
  
  def on_board?(pos)
    (0..7).cover?(pos[0]) && (0..7).cover?(pos[1])
  end
  
  WHITE_MOVES = [[-1, 1], [-1, -1]]
  RED_MOVES = [[1, 1], [1, -1]]

end

class IllegalMoveError < StandardError
end