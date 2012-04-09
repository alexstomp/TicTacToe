class PlayerHelper

  def self.new(board, player)
    @player_board = player == 1 ? board.p1_board : board.p2_board
    @opponent_board = player == 1 ? board.p2_board : board.p1_board
    @board = board
    @open_spaces = board.open_spaces
  end

  def self.finishable?(board, player)
    PlayerHelper.new(board, player)
    @board.winning_sets.each do |winning_set|
      combo = []
      winning_set.to_a.each do |set_space|
        combo << set_space if @player_board.include?(set_space)
      end
      if combo.size == 2
        winning_space = winning_set.to_a
        combo.each do |combo_space|
          winning_space.delete(combo_space)
        end
        return true if @board.open_spaces.include?(winning_space[0])
      end
    end
    return false
  end

  def self.finishing_move(board, player)
    PlayerHelper.new(board, player)
    @board.winning_sets.each do |winning_set|
      combo = []
      winning_set.to_a.each do |set_space|
        combo << set_space if @player_board.include?(set_space)
      end
      if combo.size == 2
        winning_space = winning_set.to_a
        combo.each do |combo_space|
          winning_space.delete(combo_space)
        end
        return winning_space[0] if @board.open_spaces.include?(winning_space[0])
      end
    end
  end

end
