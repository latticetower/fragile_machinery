require File.dirname(__FILE__) + '/card.rb'

class BoardCard < Card
  attr_reader :exhausted

  def initialize
    @exhausted = false
  end
end

class Board
  attr_reader :board_cards
  def initialize
    @board_cards = Array.new
  end
  
  def add(board_card)
    @board_cards << board_card
  end
end