class Narrator
  
  def self.get_player_name(writer=Writer.new, reader=Reader.new)
    writer.ask_player_name 
    name = reader.get_player_name
    return name
  end

  def self.get_player_move(writer=Writer.new, reader=Reader.new)
    writer.ask_player_move
    move = reader.get_player_move
    return move    
  end

end

class Writer

  def ask_player_name(output_stream=$stdout)
    puts 'Player 1, what is your name?'
  end

  def ask_player_move(output_stream=$stdout)
    puts "What's your move?"
  end

end
  
class Reader

  def get_player_name
    name = gets.chomp
    return name
  end

  def get_player_move
    move = gets.chomp
    return move
  end

end
