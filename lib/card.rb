class Card
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
end

class Unit < Card
  attr_reader :prod_cost, :supply_cost, 
      :health, :shield, :attack
  def initialize
  end
end

module Effect
end

class Spell < Card
  include Effect
end