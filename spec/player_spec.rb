require 'player.rb'
require 'narrator_spec.rb'

describe Player do

  it "creates a player with a name (String)" do
    player1 = MockPlayer.new(1)
    player1.name.class.should == String
  end

  it "creates player with correct value" do
    player1 = MockPlayer.new(1)
    player1.value.should == "X"
  end

  it "gets player's move (int=3)" do
    player1 = MockPlayer.new(1)
    player1.get_move.should == 3
  end

end

describe Computer do

  it "fills last available spot" do
    player = MockComputer.new(1)
    board = Board.new(3)
    board.move(0, "X")
    board.move(8, "O")
    board.move(1, "X")
    board.move(7, "O")
    board.move(6, "X")
    board.move(2, "O")
    board.move(5, "X")
    board.move(3, "O")
    player.get_move(board).should == 4
  end

  it "makes finishing move" do
    pending
    player = MockComputer.new(1)
    board = Board.new(3)
    board.move(0, "X")
    board.move(8, "O")
    board.move(1, "X")
    board.move(7, "O")
    player.get_move(board).should == 2
    board.move(6, "X")
    board.move(3, "O")
    player.get_move(board).should == 3
  end

end

class MockPlayer

  attr_reader :name, :value

  def initialize(turn, name="John")
    @writer = MockWriter.new
    @reader = MockReader.new
    name = Narrator.get_player_name(@writer, @reader)
    @name = name

    if turn == 1
      @value = "X"
    else
      @value = "O"
    end
  end

  def get_move
    @writer = MockWriter.new
    @reader = MockReader.new
    move = Narrator.get_player_move("name", @writer, @reader)
    return move
  end

end

class MockComputer < MockPlayer

  attr_reader :value

  def initialize(turn)
    if turn == 1
      @value = "X"
    else
      @value = "O"
    end
  end

  def get_move(board)
    if @value == "X"
      board.winning_sets.each_with_index do |set, set_index|
      end
    end
  end

end
