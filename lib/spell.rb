require File.dirname(__FILE__) + '/card.rb'

module Effect
end

class Spell < Card
  include Effect
  
  def initialize(name)
    super(name)
  end
end