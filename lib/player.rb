class Player

  attr_reader :name
  
  def initialize
    name = Narrator.get_player_name
    @name = name
  end

  def get_move
    move = Narrator.get_player_move
    return move
  end 

end

class Computer < Player

  def get_move(board)
    # algorithm for best move
  end 

end
