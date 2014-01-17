require File.dirname(__FILE__) + '/card.rb'
require 'json'

class Unit < Card
  attr_reader :prod_cost, :supply_cost, 
      :health, :shield, :attack
  
  def starts_acting_at
    1
  end
  
  def to_json(*a)
    {
      'name' => name,
      'prod_cost' => prod_cost,
      'supply_cost' => supply_cost,
      'health' => health,
      'shield' => shield,
      'attack' => attack
    }.to_json(*a)
  end
  
  def initialize(name)
    super(name)
  end
end
