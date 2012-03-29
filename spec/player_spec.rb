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

  it "can_win returns winning move if can win" do
    player = MockComputer.new(1)
    board = Board.new(3)
    board.board = ["X", "X", " ", "O", "O", " ", " ", " ", " "]
    board.game_state
    player.can_win(board, player.turn).should == 2
  end

  it "can_win false if can't win" do
    player = MockComputer.new(1)
    board = Board.new(3)
    board.board = ["X", " ", " ", "O", " ", " ", " ", " ", " "]
    board.game_state
    player.can_win(board, player.turn).should == false
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

  attr_reader :turn, :space_choices

  def initialize(turn)
    @turn = turn
  end

  def get_move(board)
  end

  def can_win(board, player)
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
        return winning_space[0]
      end
    end
    return false
  end

end
