require 'narrator.rb'

describe Narrator do

  before (:each) do
    @reader = MockReader.new
    @writer = MockWriter.new
  end

  it "displays winner" do
    Narrator.winner("name", @writer, @reader)
    @writer.write_count.should == 1
    @writer.wrote.should == true
  end

  it "prompts for player names" do
    Narrator.get_player_name(@writer, @reader)
    @writer.write_count.should == 1
    @writer.wrote.should == true
  end

  it "takes a player name from the user" do
    Narrator.get_player_name(@writer, @reader)
    @reader.reader_count.should == 1
    @reader.read.should == true
  end

  it "returns player name (string)" do
    Narrator.get_player_name(@writer, @reader).class.should == String
  end

  it "prompts the player for a move" do
    Narrator.get_player_move("name", @writer, @reader)
    @writer.write_count.should == 1
    @writer.wrote.should == true
  end

  it "takes player's move" do
    Narrator.get_player_move("name", @writer, @reader)
    @reader.reader_count.should == 1
    @reader.read.should == true
  end

  it "returns player's move (int=3)" do
    Narrator.get_player_move("name", @writer, @reader).should == 3
  end
end

class MockWriter

  attr_accessor :write_count, :wrote

  def initialize
    @write_count = 0
    @wrote = false
  end

  def ask_player_name(output_stream=$stdout)
    @write_count = @write_count + 1
    @wrote = true
  end

  def ask_player_move(output_stream = $stdout)
    @write_count = @write_count + 1
    @wrote = true
  end

  def winner(name)
    @write_count = @write_count + 1
    @wrote = true
  end

  def draw
    @write_count = @write_count + 1
    @wrote = true
  end

end

class MockReader

  attr_reader :reader_count, :read, :name_responses

  def initialize
    @reader_count = 0
    @read = false
    @name_responses = ["Alex", "John", "Beth", "Max", "Dan", "Doug", "Dave"]
  end

  def get_player_name
    name = @name_responses[rand(@name_responses.size-0)]
    @reader_count = @reader_count + 1
    @read = true
    return name
  end

  def get_player_move
    move = 3
    @reader_count = @reader_count + 1
    @read = true
    return move
  end

end
