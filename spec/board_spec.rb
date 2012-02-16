require 'board'

describe Board do

  it "creates a correctly sized array" do
    board = Board.new(3)
    board.board.should == [" "," "," "," "," "," "," "," "," "]
  end

  it "checks that specific space is valid move" do
    board = Board.new(3)
    board.board[4] = "X"

    board.valid_move?(0).should == true
    board.valid_move?(4).should_not == true
  end

  it "fills in a space with player_value" do
    board = Board.new(3)
    board.move(1, "X")

    board.board.should == [" ","X"," "," "," "," "," "," "," "]
  end

  it "detects a win" do
    board = Board.new(3)
    board.move(0, "X")
    board.move(3, "O")
    board.move(1, "X")
    board.move(4, "O")
    board.move(2, "X")

    board.game_state.should == :p1_win
  end

  it "detects a p2 win" do
    board = Board.new(3)
    board.move(0, "X")
    board.move(5, "O")
    board.move(1, "X")
    board.move(8, "O")
    board.move(3, "X")
    board.move(2, "O")

    board.game_state.should == :p2_win
  end

  it "detects a draw" do
    board = Board.new(3)
    board.move(0, "X")
    board.move(1, "O")
    board.move(4, "X")
    board.move(8, "O")
    board.move(2, "X")
    board.move(6, "O")
    board.move(7, "X")
    board.move(3, "O")
    board.move(5, "X")

    board.game_state.should == :draw
  end

  it "detects an incomplete" do
    board = Board.new(3)
    board.game_state.should == :incomplete
  end

  it "removes a move" do
    board = Board.new(3)
    board.move(0, "X")
    board.move(5, "O")
    board.board.should == ["X"," "," "," "," ","O"," "," "," "]
    board.open_spaces.include?(5).should == false
    board.game_state
    board.p2_board.include?(5).should == true
    board.un_move(5)
    board.board.should == ["X"," "," "," "," "," "," "," "," "]
    board.open_spaces.include?(5).should == true
    board.game_state
    board.p2_board.include?(5).should == false
  end

end

