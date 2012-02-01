require '~/Development/PROJECTS/TTT/lib/player.rb'

class Computer < Player

  attr_accessor :player_spaces, :player_value
  attr_reader :board
  
  def initialize(board)
    @player_value = 2
    @board = board
    @player_spaces = []
    @player_value = 2
  end

  def choose_space(space)
    @board.set_space(space, @player_value)
    @player_spaces << space
  end
  
  # Plays most advantageous move while there is no winner or draw
  def self.computer_turn
    board = @board.get_board
    board_open_spaces = []
    player1_squares = []
    player2_squares = []

    board.each_index do |index| 
      board_open_spaces << index if board[index] == " "
      player1_squares << index if board[index] == "X"
      player2_squares << index if board[index] == "O"
    end

    board_open_spaces.each do |space|
      evaluate_space(space, board_open_spaces, player1_squares, player2_squares, @board.move_count) 
    end
  end
   
  def evaluate_value(square, open_spaces, p1_spaces, p2_spaces, move)
    
    square_value = 0

    if move % 2 == 0
      p2_spaces << square
      open_spaces = open_spaces - [square]
    else
      p1_spaces << square
      open_spaces = open_spaces - [square]
    end

    if Board.get_game_state(p1_spaces, p2_spaces) == :incomplete
      evaluate_value(square, open_spaces, p1_spaces, p2_spaces, move)
    elsif Board.get_game_state(p1_spaces, p2_spaces) == :p1_win
      if move % 2 == 0
        square_value = square_value - 1
      else
        square_value = square_value + 1
      end
    elsif Board.get_game_state(p1_spaces, p2_spaces) == :p2_win
      if move % 2 == 0
        square_value = square_value - 1
      else
        square_value = square_value + 1
      end
    end

    open_spaces.each do |space|
      if @board.game_state == :incomplete
        
      end
    end


    next_open_spaces = current_open_spaces - square
    count = 1
    move_value = 0
    current_player_squares = []

    while game_state == 0 and next_open_spaces.length > 0
      next_open_spaces.each do |space|
        current_player_squares = @player_squares
        current_player_squares << space
        @winning_sets.each do |set|
          if set.subset? current_player_squares
            move_value -= 1
          else
            move_value += 1
          end
        end
      end
    return move_value
    end
  end
end
