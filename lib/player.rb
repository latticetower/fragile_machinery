class Player
  BASE_MP = 100
  attr_reader :prod_count, 
              :supply_count
  
  attr_reader :board
  @hand = nil
  @deck = nil
  
  def initialize
    @prod_count = 0 # let's suppose these values are zeroes at this point
    @supply_count = 0
  end
  
  def hand_size
    @hand.size
  end
end