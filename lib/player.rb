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

  attr_reader :turn, :name

  def initialize(turn)
    @name = "AI_PLAYER_" + turn.to_s
    @turn = turn
  end

  def get_move(board)

    if @turn == 1
      my_board = board.p1_board.to_set
      opponent_board = board.p2_board.to_set
    else
      my_board = board.p2_board.to_set
      opponent_board = board.p1_board.to_set
    end

    # Last Move
    if board.open_spaces.length == 1
      board.board.each_with_index do |value, index|
        return index if value == " "
      end
    end

    # Winning Move
    board.open_spaces.each do |open_space|
      current_player_board = my_board.to_set
      current_player_board.add(open_space)

      board.winning_sets.each do |set|
        return open_space if set.subset? current_player_board
      end
    end

    # Blocking Move
    board.open_spaces.each do |open_space|
      current_opponent_board = opponent_board.to_set
      current_opponent_board.add(open_space)

      board.winning_sets.each do |set|
        return open_space if set.subset? current_opponent_board
      end
    end

    # First Turn -- Computer is too slow
    if my_board.size == 0
      if board.board[4] == " "
        return 4 # middle
      else
        return 8 # bottom right
      end
    end

    # opposite corners bug
    # is this cheating? I take it as memorizing openings like chess :)
    if @turn == 1 and board.p1_board.size == 1 and board.p2_board.size == 2
      if board.p2_board == [0, 8] or board.p2_board == [2, 6]
        return 1
      end
    elsif @turn == 2 and board.p2_board.size == 1 and board.p1_board.size == 2
      if board.p1_board == [0,8] or board.p1_board == [2,6]
        return 1
      end
    end

    # Everything Else!
    best_move(board)

  end

  def best_move(board)
    move_values = {}
    board.open_spaces.each do |first_space|
      move_values[first_space] = determine_space_value(first_space, board)
    end
    return pick_value(move_values)
  end

  def determine_space_value(space, board, player=@turn, move_value=0)
    gen_board = Board.new(board.side)
    board.board.each_with_index {|value, index| gen_board.board[index] = value}
    gen_board.game_state

    player_value = (player == 1)? "X" : "O"
    gen_board.move(space, player_value)

    if gen_board.game_state == :incomplete
      gen_board.open_spaces.each do |open_space|
        next_player = (player == 1)? 2 : 1
        move_value += determine_space_value(open_space, gen_board, next_player)
      end
      return move_value
    else
      return completed_move_value(gen_board)
    end

  end

  def completed_move_value(gen_board)
    if gen_board.game_state == :p1_win and @turn == 1
      move_value = 1
    elsif gen_board.game_state == :p2_win and @turn == 2
      move_value = 1
    elsif gen_board.game_state == :draw
      move_value = 0
    else #loss
      move_value = -1
    end
    move_value
  end

  def pick_value(hash, pick=nil)
    hash.each do |key, value|
      pick = key if pick == nil or value >= hash[pick]
    end
    return pick
  end

end
