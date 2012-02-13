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

  it "chooses best of 3 moves" do
    player = MockComputer.new(1)
    board = Board.new(3)
    board.move(0, "X")
    board.move(1, "O")
    board.move(2, "X")
    board.move(3, "O")
    board.move(7, "X")
    player.get_move(board).should == 5
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

  attr_reader :turn, :value

  def initialize(turn)

    @turn = turn

    if turn == 1
      @value = "X"
    else
      @value = "O"
    end
  end

  def get_move(board)

    #updates all the player-specific arrays
    board.game_state
    #take ^^ out for actual class

    #BASECASE = FINISH GAME -- LAST SPOT
    if board.open_spaces.length == 1
      board.board.each_with_index do |value, index|
        return index if value == " "
      end
    end

    if @turn == 1
      my_board = board.p1_board.to_set
      opponent_board = board.p2_board.to_set
      opponent_value = "O"
    else
      my_board = board.p2_board.to_set
      oppent_board = board.p1_board.to_set
      opponent_value = "X"
    end

    #FINISHING MOVE
    board.open_spaces.each do |open_space|
      current_player_board = my_board.to_set
      current_player_board.add(open_space)

      board.winning_sets.each do |set|
        return open_space if set.subset? current_player_board
      end
    end

    # hash to store value for every open_space
    move_values = {}

    #STORE VALUES OF MOVES INTO HASH
    board.open_spaces.each do |open_space|
      move_value = generate_move_value(open_space, board)
      move_values[open_space] = move_value
    end

    puts move_values
    pick_value, pick = 0, 0
    #PICK RIGHT MOVE FROM THE HASH
    # ~working~
    move_values.each do |key, value|
      pick = key if value > pick_value
    end

    return pick

  end

  def generate_move_value(space, board)
    gen_board, move_value = board, 0

    if gen_board.p1_board.size == gen_board.p2_board.size
      value = "X" # P1
    else
      value = "O" # P2
    end

    gen_board.open_spaces.each do |next_move|

      gen_board.move(next_move,value)

      if gen_board.game_state == :p1_win and @turn == 1
        move_value = move_value + 1
      elsif gen_board.game_state == :p2_win and @turn == 2
        move_value = move_value + 1
      elsif gen_board.game_state == :draw
        move_value = move_value
      else
        move_value = move_value - 1
      end

    end

    return move_value

  end

end
