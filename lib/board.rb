require 'set'

class Board
  
  attr_reader :board, :p1_board, :p2_board, :winning_sets

  def initialize(side)
    @p1_board = []
    @p2_board = []
    
    w1 = Set[0,4,8]
    w2 = Set[0,1,2]
    w3 = Set[0,3,6]
    w4 = Set[1,4,7]
    w5 = Set[2,4,6]
    w6 = Set[2,5,8]
    w7 = Set[3,4,5]
    w8 = Set[6,7,8]
    @winning_sets = [w1,w2,w3,w4,w5,w6,w7,w8]

    @board = Array.new((side**2), " ")
  end

  def valid_move?(space)
    return true if @board[space] == " "
    return false
  end

  def move(space, value)
    @board[space] = value
  end

  def game_state 
    @board.each_index do |index|
      @p1_board << index if @board[index] == "X"
      @p2_board << index if @board[index] == "O"
    end
    
    @winning_sets.each do |item|
      return :p1_win if item.subset? @p1_board.to_set
      return :p2_win if item.subset? @p2_board.to_set
    end
    
    if @p1_board.size + @p2_board.size == @board.size
      return :draw
    else
      return :incomplete
    end

  end
end
