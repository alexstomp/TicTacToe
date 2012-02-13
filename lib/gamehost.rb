require '~/Development/PROJECTS/TicTacToe/lib/player.rb'
require '~/Development/PROJECTS/TicTacToe/lib/narrator.rb'
require '~/Development/PROJECTS/TicTacToe/lib/game.rb'
require '~/Development/PROJECTS/TicTacToe/lib/board.rb'

player1 = Player.new(1)
player2 = Player.new(2)

game = Game.new(3, player1, player2)

while game.get_game_state == :incomplete
  game.display_board
  move = game.player_move
  game.move(move)
end

game.display_board
game.end_result
