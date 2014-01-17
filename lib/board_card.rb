require File.dirname(__FILE__) + '/card.rb'

class BoardCard
  attr_reader :lifetime # total card lifetime from the moment it was put to board
  attr_reader :card
  
  def initialize(card)
    @card = card
    @lifetime = 0
  end
  
  def inc_lifetime(amount = 1)
    @lifetime += amount if amount > 0
    self # for method chaining
  end
  def active?
    @lifetime < Card::BASIC_LIFETIME
  end
  def exhausted?
    @lifetime >= Card::BASIC_LIFETIME
  end
end