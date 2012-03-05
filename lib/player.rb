class Player

  attr_reader :name

  def initialize(turn)
    name = Narrator.get_player_name
    @name = name
    if turn == 1
      @value = "X"
    else
      @value = "O"
    end
  end

  def get_move
    move = Narrator.get_player_move(@name)
    return move
  end

  def winner
    Narrator.winner(@name)
  end

end
