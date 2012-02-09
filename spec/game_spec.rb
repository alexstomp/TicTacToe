require 'game'

describe Game do

  it "creates a board when initializing" do
    game = Game.new(3) 
    game.board.board == Array.new(9, " ")
  end

  it "initializes turn count" do
    game = Game.new(3)
    game.turn.should == 1
  end

  it "places a move if it's valid" do
    game = Game.new(3)
    game.move(1)
    game.move(2)

    game.board.board.should == [" ","X","O"," "," "," "," "," "," "]
    game.move(2).should == :invalid_move
  end

  it "gets current game state" do
    game = Game.new(3)
    game.get_game_state.should == :incomplete
  end

  it "gets current board" do
    game = Game.new(3)
    game.get_board.should == [" "," "," "," "," "," "," "," "," "]
  end

  it "checks if move is valid" do
    game = Game.new(3)
    game.move(2)
    game.valid_move?(2).should == false
  end

  it "gets current player" do
    player1 = MockPlayer.new(1)
    player2 = MockPlayer.new(2)
    game = Game.new(3, player1, player2)
    game.move(3)
    game.player_up.should == game.players[1]
  end

end
