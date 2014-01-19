require 'json'

class Card
  BASIC_LIFETIME = 3
  
  attr_reader :name
  @@subclasses = []
  
  def initialize(name)
    @name = name
  end
  def starts_acting_at
    1
  end
  
  def to_json(*a)
    {
      'name' => @name
    }.to_json(*a)
  end
  
  def self.inherited(subclass)
    @@subclasses << subclass
  end
  
  
  def self.from_hash(card_info)
    subclass = @@subclasses.select{|c| c.name == card_info[:@type] }
    unless subclass.nil? or subclass.size == 0
      puts "ancestor with specific type found #{subclass}"
      card = subclass[0].new(card_info[:name])
      card_info.each_pair do |k, v|
        if card.instance_variable_defined? k
          card.instance_variable_set k, v
        end
      end
      card
    end
  end
end
