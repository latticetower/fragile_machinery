require 'state_machine'
class Game
  @first_player = nil
  @second_player = nil
  def users
    [ @first_player, @second_player ]
  end
  
  state_machine :initial => :created do
    state :created, :value => 0
    state :first_confirmed
    state :second_confirmed
    state :ready, :value => 1
    state :started, :value => 2
    
      state :combat, :value => 4
      state :first_moved
      state :second_moved
      state :gain, :value => 5
      state :deal, :value => 6
      
      
    state :finished, :value => 3
    
    # transitions
    transition :created => :first_confirmed, :second_confirmed => :ready, :on => :confirm1
    transition :created => :second_confirmed, :first_confirmed => :ready, :on => :confirm2
    
    transition :ready => :started, :on => :prepare_game
    transition :started => :combat, :on => :start
    transition :combat => :first_moved, :second_moved => :gain, :on => :action1
    transition :combat => :second_moved, :first_moved => :gain, :on => :action2
    transition :gain => :deal, :on => :deal_cards
    transition :gain => :combat, :on => :next_move
    transition all - [:finished] => :finished, :on => :stop
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