require 'state_machine'
class Game
  attr_protected :first_player, :second_player
  def users
    [ @first_player, @second_player ]
  end
  state_machine :state, :initial => :created do
    state :created, :value => 0
    state :ready, :value => 1
    state :started, :value => 2
    state :finished, :value => 3
  end
  
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
    @first_player, @second_player = user1, user2
  end
  #checks if user plays this game
  def played_by?(username)
    @first_player.name == username || @second_player.name == username
  end
  #checks if game is for users 1 and 2
  def played_by?(username1, username2)
    played_by?(username1) && played_by?(username2)
  end
  
  #TODO: should also find some way to get winner
  def finish!
    #should finish the game and pick one winner
  end
  
end