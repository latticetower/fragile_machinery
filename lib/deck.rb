=begin
Initially, every player has it's own deck.
Deck contains certain amount of Card objects.
At first code version deck object is treated as common and the same for all players.
At the beginning of the game players' deck gets randomly mixed and player gets some random cards from it.
=end
class Deck
  attr_reader :cards
  def initialize
    @cards = Array.new
  end
  
  def shuffle
  end
end