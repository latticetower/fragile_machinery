require 'state_machine'
require File.dirname(__FILE__) + '/player.rb'
require File.dirname(__FILE__) + '/game/game_callbacks.rb'

class Game
  @first_player = nil #stores Player object with the same name as user has
  @second_player = nil #this stores Player too
  
  include GameCallbacks
  
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
    transition :deal => :combat, :on => :next_move
    transition all - [:finished] => :finished, :on => :stop

    #state specific methods
    state :combat, :first_moved, :second_moved, :gain, :deal do
      def playable?
        true
      end
    end
    state :combat do
      def can_move?(username)
        played_by?(username)
      end
    end
    state :first_moved do
      def can_move?(username)
        @second_player.name == username
      end
    end
    state :second_moved do
      def can_move?(username)
        @first_player.name == username
      end
    end
    state all - [:combat, :first_moved, :second_moved] do
      def can_move?
        false
      end
    end
    
    state :ready do
      def prepare_cards
        # should do nothing if we are in different states
        @first_player.load_deck
        @first_player.shuffle_deck!
        @first_player.take_from_deck(4)
        
        @second_player.load_deck
        @second_player.shuffle_deck!
        @second_player.take_from_deck(5)
        
      end
    end
    
    after_transition :gain => :deal do |game, transition|
      @first_player.take_from_deck(1)
      @second_player.take_from_deck(1)
      # TODO: should ask Illionel if game ends when cards are over for both players
      next_move #and should call next_move conditionally
    end
    after_transition all => :ready do |game, transition|
      game.game_start_callback(*game.users)
      puts "before prepare cards call"
      game.prepare_cards
      puts "after prepare cards call"
      game.game_state_changed_callback
    end
    after_transition all - [:finished] => :finished do |game, transition|
      game.game_state_changed_callback
      game.game_end_callback
    end
  end
  ##
  # callbacks
  #

  #
  # end of callbacks
  
  def set_ready!
    puts "game #{state_name}"
    if created?
      puts "call confirmation methods"
      confirm1
      confirm2
    end
  end
  #game can be created only when there are two users in it
  def initialize(user_id1, user_id2)
    super() # NOTE: This *must* be called, otherwise states won't get initialized
    @first_player, @second_player = Player.new(user_id1), Player.new(user_id2)
  end
  # checks if user plays this game
  def played_by?(username)
    @first_player.name == username || @second_player.name == username
  end
  #checks if game is for users 1 and 2
  def played_by_users?(username1, username2)
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
  
  # method updates stats of board cards in gain state
  def update_stats
    # 1. update all board cards lifetime
    @first_player.board_cards.each {|bc| bc.inc_lifetime }
    @second_player.board_cards.each {|bc| bc.inc_lifetime }
    #TODO: 2. should also change board state somehow
  end
  # method is called when we need to update cards state for specified user. 
  # i.e., act with all units wich have target and didn't acted yet in this move
  # for now it's just a method stub - i need to ask Illionel for exact game rules
  def update_board_state(username)
  
  end
  # method is called by game server when user tries to put his card on board
  # 
  def handle_action(username, actiontype)
  
  end
  
  def to_json
    [
      # first player data:
      @first_player.to_hash,
      # second player data
      @second_player.to_hash
    ].to_json
  end
  

end