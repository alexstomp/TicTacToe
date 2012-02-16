class Narrator

  def self.get_game_type(writer=Writer.new, reader=Reader.new)
    writer.ask_game_type
    game_type = reader.get_game_type
    return game_type
  end

  def self.get_order(writer=Writer.new, reader=Reader.new)
    writer.ask_order
    order = reader.get_order
    return order
  end

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

  def ask_game_type
    puts 'Choose your game type:'
    puts '1: Human vs. Human'
    puts '2: Human vs. Computer'
    puts '3: Computer vs. Computer'
  end

  def ask_order
    puts 'Would you like to go first?'
    puts '1: yes'
    puts '2: no'
  end

  def ask_player_name
    puts 'New Player, what is your name?'
  end

  def ask_player_move(name)
    puts name + ", what's your move? (1-9)"
  end

  def display_board(board)
    puts "1      |2      |3      "
    puts "   " + board.board[0] + "   |   " + board.board[1] + "   |   " + board.board[2] + "   "
    puts "       |       |       "
    puts "======================="
    puts "4      |5      |6      "
    puts "   " + board.board[3] + "   |   " + board.board[4] + "   |   " + board.board[5] + "   "
    puts "       |       |       "
    puts "======================="
    puts "7      |8      |9      "
    puts "   " + board.board[6] + "   |   " + board.board[7] + "   |   " + board.board[8] + "   "
    puts "       |       |       "
    puts " "
  end

  def winner(name="AI")
    puts name + ' wins!'
  end

  def draw
    puts "It's a tie!"
  end

end

class Reader

  def get_game_type
    game_type = gets.chomp.to_i
    if game_type == 1
      return :hvh
    elsif game_type == 2
      return :hvc
    elsif game_type == 3
      return :cvc
    end
  end

  def get_order
    order = gets.chomp.to_i
    if order == 1
      return :first
    elsif order == 2
      return :last
    end
  end

  def get_player_name
    name = gets.chomp
    return name
  end

  def get_player_move
    move = gets.chomp.to_i - 1
    return move
  end

end
