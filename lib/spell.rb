require File.dirname(__FILE__) + '/card.rb'

module Effect
end

class Spell < Card
  include Effect
  
  attr_reader :prod_cost, :supply_cost
  
  def initialize(name)
    super(name)
    
    @prod_cost = 0
    @supply_cost = 0
  end
  
  def to_json(*a)
    to_hash.to_json(*a)
  end
  
  def to_hash
    {
      'name' => name,
      'prod_cost' => prod_cost,
      'supply_cost' => supply_cost,
      'type' => "spell"      
    }
  end 
end