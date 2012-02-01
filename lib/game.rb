require '~/Development/PROJECTS/TTT/lib/player.rb' 
require '~/Development/PROJECTS/TTT/lib/computer.rb'
require '~/Development/PROJECTS/TTT/lib/board.rb'

class Game 
  
  attr_accessor :board, :turn, :players
  attr_reader :winner, :result
  
  def initialize(side, type)

    @board = Board.new(side)
        
    @players = []
    
    if type == "pvp" 
      
      puts "Player 1 name?"
      player1_name = gets
      @players << Player.new(@board, player1_name)

      puts "Player 2 name?"
      player2_name = gets
      @players << Player.new(@board, player2_name)

    elsif type == "pvc"

      puts "Player 1 name?"
      player1_name = gets
      @players << Player.new(@board, player1_name)

      @players << Computer.new(@board)

    else
      @players << Computer.new(@board)
      @players << Computer.new(@board)
    end

    @turn = 1
    
  end
  
  def move(space)
    if @turn == 1
      @players[0].choose_space(space, "X")
      @turn += 1
    else
      @players[1].choose_space(space, "O")
      @turn -= 1
    end
  end
  
  def get_game_state
    @board.get_game_state(@players[0].player_spaces, @players[1].player_spaces)
  end
  
  def get_board
    @board.get_board
  end

  def valid_move?(move)
    return @board.valid_move?(move)
  end

end


