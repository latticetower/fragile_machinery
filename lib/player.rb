class Player
  BASE_MP = 100
  attr_reader :prod_count, 
              :supply_count
  
  attr_reader :board
  @hand 
  @deck # enumerator?
  @deck_position
  attr_reader :name
  
  def initialize(name)
    @prod_count = 0 # let's suppose these values are zeroes at this point
    @supply_count = 0
    @name = name
    @deck = Array.new
    @hand = []
  end
  
  def hand_size
    @hand.size
  end

  def deck_size
    @deck.size
  end
  #method should load deck
  def load_deck
    File.open(File.dirname(__FILE__) + '/deck.txt') do |file|
      begin
        @deck = eval(file.lines.to_a.join('') ).map{ |card| Card.from_hash(card) }
      rescue Exception => e
        puts "got exception #{e.message}"
        @deck = []
      end
    end
  end
  
  # method should shuffle player's deck
  def shuffle_deck!
    @deck.shuffle
    @deck_position = @deck.each
  end
  
  # let's be more informative - let's return number of cards taken from deck successfully
  def take_from_deck(number_of_cards)
    @deck_position ||= @deck.each
    cards_taken = 0
    # @hand += @deck_position.take(number_of_cards)
    begin
      number_of_cards.times do |i| 
        @hand << @deck_position.next 
        cards_taken += 1
      end
    rescue StopIteration => e
      # not good, i know, but there is nothing to do here
    end
    cards_taken
  end
end