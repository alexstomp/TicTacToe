require '~/Development/PROJECTS/TicTacToe/lib/player.rb'
require '~/Development/PROJECTS/TicTacToe/lib/narrator.rb'
require '~/Development/PROJECTS/TicTacToe/lib/game.rb'
require '~/Development/PROJECTS/TicTacToe/lib/board.rb'

type = Narrator.get_game_type

if type == :hvh
  player1 = Player.new(1)
  player2 = Player.new(2)
elsif type == :hvc
  order = Narrator.get_order
  if order == :first
    player1 = Player.new(1)
    player2 = Computer.new(2)
  else
    player1 = Computer.new(1)
    player2 = Player.new(2)
  end
else
  player1 = Computer.new(1)
  player2 = Computer.new(2)
end

game = Game.new(3, player1, player2)

while game.get_game_state == :incomplete
  if game.player_up.class == Player
    game.display_board
  end
  move = game.player_move
  game.move(move)
end

game.display_board
game.end_result
