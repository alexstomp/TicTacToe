require 'player'

class Computer < Player

  attr_reader :turn, :name

  def initialize(turn)
    @name = "AI_PLAYER_" + turn.to_s
    @turn = turn
  end

 def get_move(board)
    space_values = {}
    board.open_spaces.each do |origin_space|
      space_values[origin_space] = branch(board, origin_space).to_f
    end
    puts space_values
    pick_value(space_values)
  end

  def branch(board, space, depth=1, value=0)
    gen_board = Board.new(board.side)
    board.board.each_with_index {|value, index| gen_board.board[index] = value}
    gen_board.game_state

    player_value = (board.p1_board.size > board.p2_board.size) ? "O" : "X"

    gen_board.move(space, player_value)

    if gen_board.game_state == :incomplete
      gen_board.open_spaces.each do |next_space|
        value = branch(gen_board, next_space, depth+1, value) if depth <= 3
      end
    else
      value += assign_value(gen_board, depth)
    end
    value
  end

  def assign_value(finished_board, depth)
    if finished_board.game_state == :p1_win and @turn == 1
      1.fdiv(depth)
    elsif finished_board.game_state == :p2_win and @turn == 2
      1.fdiv(depth)
    elsif finished_board.game_state == :draw
      0
    else
      -1.fdiv(depth)
    end
  end

  def pick_value(hash, pick=nil)
    hash.each do |key, value|
      pick = key if pick == nil or value >= hash[pick]
    end
    pick
  end

end
