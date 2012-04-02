require 'player.rb'
require 'computer.rb'
require 'board.rb'
require 'narrator_spec.rb'

describe Player do

  it "creates a player with a name (String)" do
    player1 = MockPlayer.new(1)
    player1.name.class.should == String
  end

  it "creates player with correct turn stored" do
    player1 = MockPlayer.new(1)
    player1.turn.should == 1
  end

  it "gets player's move (int=3)" do
    player1 = MockPlayer.new(1)
    player1.get_move.should == 3
  end

end

describe Computer do

  before(:each) do
    @player = MockComputer.new(2)
    @board = Board.new(3)
  end

  it "finishing_move function returns winning move if can win" do
    @board.board = ["X", "X", " ", "O", "O", " ", " ", " ", " "]
    @board.game_state
    @player.finishing_move(@board, @player.turn).should == 5
  end

  it "finishing_move function doesn't return taken spaces" do
    @board.board = ["X", " ", " ", "O", "O", " ", "X", " ", " "]
    @board.game_state
    @player.finishing_move(@board, @player.turn).should_not == 3
  end

  it "finishing_move function false if can't be finished" do
    @board.board = ["X", " ", " ", "O", " ", " ", " ", " ", " "]
    @board.game_state
    @player.finishing_move(@board, @player.turn).should == false
  end

  it "picks highest valued key in hash" do
    hash = {0 => 1, 1 => 2, 2 => 3}
    @player.pick_value(hash).should == 2
  end

  it "makes a winning move" do
    @board.board = ["O", "O", " ", "X", "X", " ", " ", " ", " "]
    @board.game_state
    @player.get_move(@board).should == 2
  end

  it "works 1" do
    @board.board = ["X", " ", " ", " ", " ", " ", " ", " ", " "]
    @board.game_state
    @player.get_move(@board).should == 4
  end

  it "works 2" do
    @board.board = [" ", " ", "X", " ", " ", " ", " ", " ", " "]
    @board.game_state
    @player.get_move(@board).should == 4
  end

  it "works 3" do
    @board.board = [" ", " ", " ", " ", " ", " ", " ", " ", "X"]
    @board.game_state
    @player.get_move(@board).should == 4
  end

  it "works 4" do
    @board.board = [" ", " ", " ", " ", " ", " ", "X", " ", " "]
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

class MockPlayer

  attr_reader :name, :turn

  def initialize(turn, name="John")
    @writer = MockWriter.new
    @reader = MockReader.new
    name = Narrator.get_player_name(@writer, @reader)
    @name = name
    @turn = turn
  end

  def get_move
    @writer = MockWriter.new
    @reader = MockReader.new
    move = Narrator.get_player_move("name", @writer, @reader)
    return move
  end

end

class MockComputer < MockPlayer

  attr_reader :turn

  def initialize(turn)
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
      value += self.class.assign_value(depth)
    elsif loss != false and current_player == player
      value += self.class.assign_value(depth, false)
    elsif gen_board.game_state == :incomplete
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
      pick = key if pick == nil or value >= hash[pick]
    end
    pick
  end
end
