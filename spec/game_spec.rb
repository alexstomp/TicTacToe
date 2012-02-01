require 'game'

describe Board do

  it "should initialize 2 players and a board when initializing a Game" do
    game = Game.new(1, "Joe")
    
    game.get_board.should == [0]
    game.players[0].class.should == Player
    game.players[0].name.should == "Joe"
    game.players[1].class.should == Computer
  end
  
  it "should change the first 2 positions on the Board, and :player_spaces is updated" do
    game = Game.new(3, "Joe")
    
    game.move(0)
    game.move(1)

    game.players[0].player_spaces.should == [0]
    game.players[1].player_spaces.should == [1]
    game.get_board.should == [1,2,0,0,0,0,0,0,0]
  end

  it "should return a draw for status of the game and print out 'Draw'" do
    game = Game.new(3, "Joe")
    
    game.move(0)
    game.move(4)
    game.move(2)
    game.move(1)
    game.move(7)
    game.move(6)
    game.move(8)
    game.move(5)
    game.move(3)
        
    game.get_game_state.should == 3
  end
  
  it "should return 1 for a player 1 win" do
    game = Game.new(3, "Joe")
    
    game.move(0)
    game.move(6)
    game.move(1)
    game.move(7)
    game.move(2)
    
    game.get_game_state.should == 1
  end
  
  it "should return 2 for a player 2 win" do
    game = Game.new(3, "Joe")
    
    game.move(3)
    game.move(0)
    game.move(6)
    game.move(1)
    game.move(7)
    game.move(2)
    
    game.get_game_state.should == 2
  end
  
  it "should return 0 for game_state to represent 'normal state'" do
    game = Game.new(3, "Joe")
    
    game.move(2)
    
    game.get_game_state.should == 0
  end
  
end
