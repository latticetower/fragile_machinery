require File.dirname(__FILE__) + '/card.rb'

class Unit < Card
  attr_reader :prod_cost, :supply_cost, 
      :health, :shield, :attack
  def initialize(name)
    super(name)
  end
end
