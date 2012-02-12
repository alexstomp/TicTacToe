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

class Computer < Player

  def initialize(turn)
    if turn == 1
      @value = "X"
    else
      @value = "O"
    end
  end

  def get_move(board)
    if board.open_spaces.length == 1
      board.board.each_with_index do |value, index|
        return index if value == " "
      end
    end
    board.open_spaces.each do |open_space|
      if @turn == 1
        current_player_board = board.p1_board.to_set
      else
        current_player_board = board.p2_board.to_set
      end
      current_player_board.add(open_space)
      board.winning_sets.each do |set|
        return open_space if set.subset? current_player_board
      end
    end
  end

  def winner
    Narrator.winner("Computer")
  end

end
