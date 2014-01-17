require 'state_machine'
require 'json'

class User
  attr_accessor :name
  attr_reader :is_busy
  
  state_machine :initial => :free do
    state :in_game
    state :disconnected
    transition :free => :in_game, :on => :start_game
    transition all => :disconnected, :on => :disconnect
  end
  def initialize(name)
    super()
    @is_busy = false
    @name = name
  end
  
  def busy?
    is_busy
  end
  
  # serialization to json:
  def to_json(*a)
    {
      'name' => @name, 
      'busy' => is_busy, 
      'state' => state_name
    }.to_json(*a)
  end
  
end