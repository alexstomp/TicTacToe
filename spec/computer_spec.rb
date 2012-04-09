require 'player.rb'
require 'computer.rb'
require 'player_helper.rb'
require 'board.rb'
require 'narrator_spec.rb'
require 'player_spec.rb'
require 'player_helper_spec.rb'

describe Computer do

  before(:each) do
    @player = MockComputer.new(2)
    @board = Board.new(3)
  end

  it "picks highest valued key in hash" do
    hash = {0 => 1, 1 => 2, 2 => 3}
    @player.pick_value(hash).should == 2
  end

  it "makes a winning move" do
    @board.board = ["X", "X", " ", "O", "O", " ", "X", " ", " "]
    @board.game_state
    @player.get_move(@board).should == 5
  end

  it "works 1" do
    @board.board = ["X", " ", " ", " ", " ", " ", " ", " ", " "]
    @board.game_state
    @player.get_move(@board).should == 4
  end

  it "makes a blocking move" do
    @board.board = ["X", " ", " ", "O", "O", " ", "X", " ", " "]
    @board.game_state
    @player.get_move(@board).should == 5
  end

  it "makes a blocking move" do
    @board.board = ["O", " ", " ", " ", " ", " ", "O", " ", "X"]
    @board.game_state
    @player.get_move(@board).should == 3
  end

  it "assigns value correctly with depth for loss" do
    MockComputer.assign_value(4, false).should == -1.fdiv(4*4)
  end

  it "assigns value correctly with depth for win" do
    MockComputer.assign_value(5).should == 1.fdiv(5*5)
  end

end

class MockComputer < MockPlayer

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
    if PlayerHelper.finishable?(board, @turn) == false
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
