require 'state_machine'

class Game
  @first_player = nil #stores Player object with the same name as user has
  @second_player = nil #this stores Player too
  
  def users
    [ @first_player, @second_player ]
  end
  
  state_machine :initial => :created do
    state :created
    state :first_confirmed
    state :second_confirmed
    state :ready
    state :started
    
      state :combat
      state :first_moved
      state :second_moved
      state :gain
      state :deal
      
      
    state :finished
    
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
    
    #state specific methods
    state :combat, :first_moved, :second_moved, :gain, :deal do
      def playable?
        true
      end
    end
    state :ready do
      def prepare_cards
        # should do nothing if we are in different states
        @first_player.load_deck
        @first_player.shuffle_deck!
        @first_player.take_from_deck(5)
        
        @second_player.load_deck
        @second_player.shuffle_deck!
        @second_player.take_from_deck(5)
      end
    end
  end

  #game can be created only when there are two users in it
  def initialize(user1, user2)
    super() # NOTE: This *must* be called, otherwise states won't get initialized
    @first_player, @second_player = Player.new(user1), Player.new(user2)
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
  
  # method checks if user with specified name is in game. if he is, do state transition
  # does nothing otherwise
  def confirmed_by(username)
    self.confirm1 if @first_player.name == username
    self.confirm2 if @second_player.name == username
  end
  

  
  
end