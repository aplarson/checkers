require_relative 'checker_board'

class Game
  attr_accessor :active_player
  attr_reader :board, :white_player, :red_player
  
  def initialize(new_game = true)
    @board = Board.new(new_game)
    @red_player = HumanPlayer.new(:red)
    @white_player = HumanPlayer.new(:white)
    @active_player = :white
  end
  
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
  
  def switch_player
    @active_player = (@active_player == :white ? :red : :white)
  end
  
  def get_move(color)
    color == :white ? white_player.move : red_player.move
  end
  
  def play
    until board.won? || board.without_moves?(@active_player)
      turn
    end
    board.display
    if board.won?
      board.winner
    else
      draw
    end
  end
  
  def draw
    puts "The game is a draw"
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

Game.new.play