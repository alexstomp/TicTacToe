require 'player'
require 'player_helper'

class Computer < Player

  attr_reader :name, :turn, :opponent, :player_value, :opponent_value

  def initialize(turn)
    @name = "AI_PLAYER_" + turn.to_s
    @turn = turn
    @opponent = @turn == 1 ? 2 : 1
    @player_value = turn == 1 ? "X" : "O"
    @opponent_value = turn == 1 ? "O" : "X"
  end

  def get_move(board)
    space_values = {}
    if board.open_spaces.length == 9
      corners = [0,2,6,8]
      return corners[Random.rand(0..3)]
    elsif board.open_spaces.length == 8
      return 4 if board.valid_move?(4)
    elsif PlayerHelper.finishable?(board, @turn) == false
      board.open_spaces.each do |open_space|
        move_value = get_branch(board, open_space)
        space_values[open_space] = (move_value*100).round / 100.0
      end
      pick_value(space_values)
    else
      PlayerHelper.finishing_move(board, @turn)
    end
  end

  def get_branch(board, space, depth=1, value=0)
    current_player = depth%2 == 0 ? @opponent : @turn
    gen_board = copy_board(board)
    depth%2 == 0 ? gen_board.move(space, @opponent_value) : gen_board.move(space, @player_value)
    post_move_branching(gen_board, current_player, depth+=1)
  end

  def post_move_branching(board, current_player, depth, value=0)
    if current_player == @opponent and PlayerHelper.finishable?(board, @turn)
      return self.class.assign_value(depth)
    elsif current_player == @turn and PlayerHelper.finishable?(board, @opponent)
      return self.class.assign_value(depth, false)
    elsif board.game_state == :incomplete
      board.open_spaces.each do |next_space|
        value += get_branch(board, next_space, depth)
      end
    end
    return value
  end

  def copy_board(board)
    gen_board = Board.new(3)
    board.board.each_with_index {|value, index| gen_board.board[index] = value}
    gen_board.game_state
    return gen_board
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
