require 'set'

class Board
  
  attr_accessor :board, :move_count
  attr_reader :winning_sets
  
  def initialize(side)
    w1 = Set[0,4,8]
    w2 = Set[0,1,2]
    w3 = Set[0,3,6]
    w4 = Set[1,4,7]
    w5 = Set[2,4,6]
    w6 = Set[2,5,8]
    w7 = Set[3,4,5]
    w8 = Set[6,7,8]
    @winning_sets = [w1,w2,w3,w4,w5,w6,w7,w8]
    
    @move_count = 1
    @board = []
    @board = Array.new((side*side)," ")
  end
  
  def get_board
    return @board  
  end
  
  def set_space(space, player_value)
    @board[space] = player_value
    @move_count += 1
  end
  
  # Returns 0 for keep playing, 1 for p1 win, 2 for p2 (COMPUTER) win, 3 for draw
  def get_game_state(p1_spaces, p2_spaces)
    if find_winner(p1_spaces, p2_spaces) != false
      find_winner(p1_spaces, p2_spaces)
    elsif @move_count == (@board.length)
      return :draw
    else
      return :incomplete
    end
  end

  # Returns :winner if there is one, and False if there is not.
  def find_winner(p1_spaces, p2_spaces)
    player1 = p1_spaces.to_set
    player2 = p2_spaces.to_set

    @winning_sets.each do |item|
      return :p1_win if item.subset? player1
      return :p2_win if item.subset? player2
    end
    
  end

  def valid_move?(move)
    return (@board[move] == " " ? true : false)
  end
  
end
