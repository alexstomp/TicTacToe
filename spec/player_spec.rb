require 'player.rb'
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

  it "fills any last available spot" do
    player = MockComputer.new(1)
    board = Board.new(3)
    board.move(0, "X")
    board.move(8, "O")
    board.move(1, "X")
    board.move(7, "O")
    board.move(6, "X")
    board.move(2, "O")
    board.move(4, "X")
    board.move(3, "O")
    player.get_move(board).should == 5
  end

  it "makes finishing move" do
    player = MockComputer.new(1)
    board = Board.new(3)
    board.board = ["X", "X", " ", " ", " ", " ", " ", "O", "O"]
    player.get_move(board).should == 2
    board2 = Board.new(3)
    board2.board = ["X", "X", "O", " ", " ", " ", "O", "O", "X"]
    player.get_move(board2).should == 4
  end

  it "makes defensive move" do
    player = MockComputer.new(2)
    board = Board.new(3)
    board.board = ["X", "O", "X", "O", "O", "X", " ", "X", " "]
    board.game_state
    player.best_move(board).should == 8
  end

  it "chooses best of 3 moves at the end" do
    player = MockComputer.new(1)
    board = Board.new(3)
    board.board = ["X", "O", "X", "O", "O", " ", " ", "X", " "]
    board.game_state
    player.best_move(board).should == 5
  end

  it "chooses best of 4 moves" do
    player = MockComputer.new(2)
    board = Board.new(3)
    board.board = ["X", "O", "X", "O", " ", " ", " ", "X", " "]
    board.game_state
    player.best_move(board).should == 4
  end

  it "blocks corners opening" do
    player = MockComputer.new(2)
    board = Board.new(3)
    board.board = ["X", " ", " ", " ", "O", " ", " ", " ", "X"]
    board.game_state
    puts player.best_move(board)
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
    @space_choices = []
  end

  def get_move(board)

    #updates all the player-specific arrays
    board.game_state
    #take ^^ out for actual class

    if @turn == 1
      my_board = board.p1_board.to_set
    else
      my_board = board.p2_board.to_set
    end

    #BASECASE = FINISH GAME -- LAST SPOT
    if board.open_spaces.length == 1
      board.board.each_with_index do |value, index|
        return index if value == " "
      end
    end

    #FINISHING MOVE
    board.open_spaces.each do |open_space|
      current_player_board = my_board.to_set
      current_player_board.add(open_space)

      board.winning_sets.each do |set|
        return open_space if set.subset? current_player_board
      end
    end

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
