require 'player'

class Computer < Player

  attr_reader :turn, :name

  def initialize(turn)
    @name = "AI_PLAYER_" + turn.to_s
    @turn = turn
  end

  def get_move(board)
    space_values = {}

    win = finishing_move(board, @turn)
    if win == false
      board.open_spaces.each do |open_space|
        move_value = get_branch(board, open_space)
        space_values[open_space] = (move_value*100).round / 100.0
      end
      pick_value(space_values)
    else
      return win
    end
  end

  def get_branch(board, space, depth=1, value=0)

    player = @turn
    opponent = player == 1 ? 2 : 1
    current_player = depth%2 == 0 ? opponent : player

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

    depth += 1
    if win != false and current_player == opponent
      return self.class.assign_value(depth)
    elsif loss != false and current_player == player
      return self.class.assign_value(depth, false)
    elsif gen_board.game_state == :incomplete and gen_board.open_spaces.size > depth
      gen_board.open_spaces.each do |next_space|
        value += get_branch(gen_board, next_space, depth)
      end
    end
    return value
  end

  def finishing_move(board, player)

    player_board = player == 1 ? board.p1_board : board.p2_board

    board.winning_sets.each do |winning_set|
      combo_spaces = 0
      combo = []
      winning_set.to_a.each do |set_space|
        if player_board.include?(set_space)
          combo_spaces += 1
          combo << set_space
        end
        if combo_spaces == 2
          winning_space = winning_set.to_a
            combo.each do |combo_space|
              winning_space.delete(combo_space)
            end
          return winning_space[0] if board.open_spaces.include?(winning_space[0])
        end
      end
    end
    return false
  end

  def self.assign_value(depth, win=true)
    val = win == true ? 1.fdiv(depth*depth) : -1.fdiv(depth*depth)
  end

  def pick_value(hash, pick=nil)
    hash.each do |key, value|
      pick = key if pick == nil or value > hash[pick]
    end
    pick
  end
end
