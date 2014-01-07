require 'state_machine'
class Game
  state_machine :phase, :initial => :undefined, :namespace => 'phase' do
    event :fight do
      transition all => :combat
    end

    event :next do
      transition :combat => :decl, :decl => :gain
    end
    event :prev do
      transition :decl => :combat, :gain => :decl
    end
    
    state :undefined, :value => 0
    state :combat, :value => 1
    state :decl, :value => 2
    state :gain, :value => 3
  end

  #game can be created only when there are two users in it
  def initialize(user1, user2)
    super() # NOTE: This *must* be called, otherwise states won't get initialized
  end
end