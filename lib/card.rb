class Card
  attr_reader :name
  @@subclasses = []
  def initialize(name)
    @name = name
  end
  def self.inherited(subclass)
    @@subclasses << subclass
  end
   
  def self.from_hash(card)
    subclass = @@subclasses.select{|c| c.name == card[:@type] }
    unless subclass.nil? or subclass.size == 0
      # puts "ancestor with specific type found #{subclass}"
      s = subclass[0].new(card[:name])
      card.each_pair do |k, v|
        if s.instance_variable_defined? k
          s.instance_variable_set k, v
        end
      end
      s
    end
  end
end

class Unit < Card
  attr_reader :prod_cost, :supply_cost, 
      :health, :shield, :attack
  def initialize(name)
    super(name)
  end
end

module Effect
end

class Spell < Card
  include Effect
  
  def initialize(name)
    super(name)
  end
end