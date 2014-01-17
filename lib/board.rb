require File.dirname(__FILE__) + '/board_card.rb'


class Board
  attr_reader :board_cards
  def initialize
    @board_cards = Array.new
  end
  
  def add(board_card)
    @board_cards << board_card
  end
end