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
    @name = name
  end
  
  def busy?
    is_busy
  end
  
end