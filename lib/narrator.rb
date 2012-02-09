class Narrator

  def self.get_player_name(writer=Writer.new, reader=Reader.new)
    writer.ask_player_name
    name = reader.get_player_name
    return name
  end

  def self.get_player_move(name, writer=Writer.new, reader=Reader.new)
    writer.ask_player_move(name)
    move = reader.get_player_move
    return move
  end

  def self.display_board(board, writer=Writer.new, reader=Reader.new)
    writer.display_board(board)
  end

  def self.winner(name, writer=Writer.new, reader=Reader.new)
    writer.winner(name)
  end

  def self.draw(writer=Writer.new, reader=Reader.new)
    writer.draw
  end

end

class Writer

  def ask_player_name
    puts 'New Player, what is your name?'
  end

  def ask_player_move(name)
    puts name + ", what's your move? (1-9)"
  end

  def display_board(board)
    puts "     |     |     "
    puts "  " + board.board[0] + "  |  " + board.board[1] + "  |  " + board.board[2] + "  "
    puts "     |     |     "
    puts "================="
    puts "     |     |     "
    puts "  " + board.board[3] + "  |  " + board.board[4] + "  |  " + board.board[5] + "  "
    puts "     |     |     "
    puts "================="
    puts "     |     |     "
    puts "  " + board.board[6] + "  |  " + board.board[7] + "  |  " + board.board[8] + "  "
    puts "     |     |     "
  end

  def winner(name)
    puts name + ' wins!'
  end

  def draw
    puts "It's a tie!"
  end

end

class Reader

  def get_player_name
    name = gets.chomp
    return name
  end

  def get_player_move
    move = gets.chomp.to_i - 1
    return move
  end

end
