require '~/Development/PROJECTS/TTT/lib/game.rb'

class TicTacToe
   
  attr_accessor :game, :move_count, :game_type
 
  def initialize 
      
    puts "Game Type? (pvp) (pvc) (cvc)"
    type = gets.chomp
    
    @game = Game.new(3, type)

    @move_count = 1
  
  end

  def display_game_board
    puts "     |     |     "
    puts "  " + game.get_board[0] + "  |  " + game.get_board[1] + "  |  " + game.get_board[2] + "  "
    puts "     |     |     "
    puts "================="
    puts "     |     |     "
    puts "  " + game.get_board[3] + "  |  " + game.get_board[4] + "  |  " + game.get_board[5] + "  "
    puts "     |     |     "
    puts "================="
    puts "     |     |     "
    puts "  " + game.get_board[6] + "  |  " + game.get_board[7] + "  |  " + game.get_board[8] + "  "
    puts "     |     |     "
  end

  def game_state
    @game.get_game_state
  end

  def get_move
    
    if @move_count % 2 == 0
      player_up = @game.players[1]
    else
      player_up = @game.players[0]
    end

    if player_up.class == Computer
      move = get_computer_move    
      return move
    else
      display_game_board
      puts (@move_count % 2 != 0 ? @game.players[0].name : @game.players[1].name).chomp + ", What's your move? (1-9)"
      return gets.chomp.to_i - 1
    end
  end

  def get_computer_move
    Computer.computer_turn
  end

  def valid_move?(move)
    @game.valid_move?(move)
  end

  def execute_move(move)
    @game.move(move)
    @move_count += 1
  end
  
  def show_result
    if game_state == :p1_win
      display_game_board
      puts @game.players[0].name.chomp + " wins!!!"
    elsif game_state == :p2_win
      display_game_board
      puts @game.players[1].name.chomp + " wins!!!"
    else 
      display_game_board
      puts @game.players[0].name.chomp + " and " + @game.players[1].name.chomp + " are evenly matched ... for now!"
    end
  end

end
