require 'player'

class Computer < Player

  attr_reader :turn, :name

  def initialize(turn)
    @name = "AI_PLAYER_" + turn.to_s
    @turn = turn
  end

  def get_move(board)
    space_values = {}

    finish = finishing_move(board, @turn)
    if finish == false
      board.open_spaces.each do |open_space|
        move_value = get_branch(board, open_space)
        space_values[open_space] = (move_value*100).round / 100.0
      end
      pick_value(space_values)
    else
      finish
    end
  end

  def get_branch(board, space, depth=1, value=0)

    player = @turn
    opponent = player == 1 ? 2 : 1

    gen_board = Board.new(3)
    board.board.each_with_index {|value, index| gen_board.board[index] = value}
    gen_board.game_state

    if player == 1
      player_value = (depth%2) == 0 ? "O" : "X"
    elsif opponent == 1
      player_value = (depth%2) == 0 ? "X" : "O"
    end

    gen_board.move(space, player_value)

    win = finishing_move(gen_board, player)
    loss = finishing_move(gen_board, opponent)

    if win != false
      value += Computer.assign_value(depth)
    elsif loss != false
      value += Computer.assign_value(depth, false)
    elsif gen_board.game_state == :incomplete
      gen_board.open_spaces.each do |next_space|
        depth += 1
        value += get_branch(gen_board, next_space, depth)
      end
    end
    value
  end

  def finishing_move(board, player)

    if player == 1
      player_board = board.p1_board
    else
      player_board = board.p2_board
    end

    board.winning_sets.each do |winning_set|
      combo_spaces = 0
      combo = []
      winning_set.to_a.each do |set_space|
        if player_board.include?(set_space)
          combo_spaces += 1
          combo << set_space
        end
      end
      if combo_spaces == 2
        winning_space = winning_set.to_a
        combo.each do |combo_space|
          winning_space.delete(combo_space)
        end
        return winning_space[0] if board.open_spaces.include?(winning_space[0])
      end
    end
    return false
  end

  def self.assign_value(depth, win=true)
    if win
      val = 1.fdiv(depth*depth)
    else
      val = -1.fdiv(depth*depth)
    end
    return val
  end

  def pick_value(hash, pick=nil)
    hash.each do |key, value|
      pick = key if pick == nil or value >= hash[pick]
    end
    pick
  end

end
