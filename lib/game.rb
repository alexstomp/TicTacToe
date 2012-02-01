class Game 
  
  attr_reader :board, :players, :turn

  def initialize(size, player1=nil, player2=nil)
    @board = Board.new(size)

    @players = Array.new
    @players << player1
    @players << player2

    @turn = 1
  end

  def move(space)
    if valid_move?(space)
      value = ((@turn % 2 == 0) ? "O" : "X")
      @board.move(space, value)
      @turn += 1
    else
      return :invalid_move
    end
  end

  def get_game_state
    @board.game_state
  end

  def get_board
    @board.board
  end

  def valid_move?(space)
    @board.valid_move?(space)
  end

  def player_up
    if @turn % 2 == 0
      return @players[1]
    else
      return @players[0]
    end
  end

  def player_move
    if player_up.class == Computer
      player_up.get_move(@board)
    else
      player_up.get_move
    end
  end

end
