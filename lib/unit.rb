require File.dirname(__FILE__) + '/card.rb'
require 'json'

class Unit < Card
  attr_reader :prod_cost, :supply_cost, 
      :health, :shield, :attack
  
  
  def starts_acting_at
    1
  end
  
  def to_json(*a)
    to_hash.to_json(*a)
  end
  
  def to_hash
    {
      'name' => name,
      'prod_cost' => prod_cost,
      'supply_cost' => supply_cost,
      'health' => health,
      'shield' => shield,
      'attack' => attack,
      'type' => "unit"
    }
  end  
  
  def initialize(name)
    super(name)
    
    @prod_cost = 0
    @supply_cost = 0   
    @health = 0
    @shield = 0
    @attack = 0
  end
end
