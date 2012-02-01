class Player
  
  attr_accessor :name, :player_spaces, :player_value
  attr_reader :board
 
  def initialize(board, name)
    @player_value = 1
    @name = name
    @board = board
    @player_spaces = []
  end
  
  def choose_space(space, value)
    if @board.get_board
      @board.set_space(space, value) 
      @player_spaces << space
    end
  end
  
end
