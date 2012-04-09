require 'board.rb'
require 'player_helper.rb'

describe PlayerHelper do

  before(:each) do
    @board = Board.new(3)
  end

  it "finishable? function returns true move if can win" do
    @board.board = ["X", "X", " ", "O", "O", " ", " ", " ", " "]
    @board.game_state
    PlayerHelper.finishable?(@board, 1).should == true
  end

  it "finishable? function false if can't be finished" do
    @board.board = ["X", " ", " ", "O", " ", " ", " ", " ", " "]
    @board.game_state
    PlayerHelper.finishable?(@board, 1).should == false
  end

  it "finishable? doesnt return the weird sets" do
    @board.board = ["X", "O", " ", " ", "O", " ", " ", " ", "X"]
    @board.game_state
    PlayerHelper.finishable?(@board, 1).should == false
  end

  it "finishing_move function returns finishing move space" do
    @board.board = ["X", "X", " ", "O", "O", " ", " ", " ", " "]
    @board.game_state
    PlayerHelper.finishing_move(@board, 1).should == 2
  end

end
