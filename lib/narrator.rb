require '~/Development/PROJECTS/TTT/lib/tictactoe.rb'

  ##  Different initializing args for different types of games
  #   P vs P, P vs C, C vs C

  ttt = TicTacToe.new

  while ttt.game_state == :incomplete
    move = ttt.get_move
    if ttt.valid_move?(move)
      ttt.execute_move(move)
    end
  end

  ttt.show_result
