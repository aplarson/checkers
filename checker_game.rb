require_relative 'checker_board'

class Game
  attr_accessor :active_player
  attr_reader :board, :white_player, :red_player
  
  def initialize
    @board = Board.new
    @red_player = HumanPlayer.new(:red)
    @white_player = HumanPlayer.new(:white)
    @active_player = :white
  end
  
  def play
    until board.won? || board.without_moves?(@active_player)
      turn
    end
    end_game
  end
  
  private
  
  def turn
    begin
    board.display
    piece, moves = get_move(active_player)
    raise IllegalMoveError if board[piece].nil? || 
      board[piece].color != active_player
    board[piece].perform_moves(moves)
    rescue IllegalMoveError
      retry
    end
    switch_player
  end
  
  def end_game
    board.display
    if board.won?
      board.winner
    else
      draw
    end
  end
  
  def switch_player
    @active_player = (@active_player == :white ? :red : :white)
  end
  
  def get_move(color)
    color == :white ? white_player.move : red_player.move
  end
  
end

class HumanPlayer
  attr_reader :color
  
  def initialize(color)
    @color = color
  end
  
  def move
    puts "It is your turn, #{color} player"
    puts "What piece would you like to move?"
    piece = gets.chomp.split(", ").map { |num| num.to_i }
    raise IllegalMoveError if piece.length != 2
    puts "To which squares would you like to move?"
    moves = gets.chomp.split("; ").map do |move|
      move.split(", ").map { |num| num.to_i }
    end
    raise IllegalMoveError if moves.any? { |move| move.length != 2 }
    [piece, moves]
  end
end

class IllegalMoveError < StandardError
end

Game.new.play