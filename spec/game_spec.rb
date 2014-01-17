require 'minitest/autorun'
require File.dirname(__FILE__) + '/../lib/game.rb'

describe "Game", "Game primitive test" do
  describe "new method call" do
    it "should create new Game object" do
      Game.new("n1", "n2").must_be_instance_of Game
      # Game.new("n1", "n1") # should raise error
      # Game.new("n1", "n2") # should raise error or return handle to previously created game
    end
  end
  
  describe "game stages" do
    it "should be in created state when created" do
      game = Game.new("p1", "p2")
      game.state_name.must_equal :created
    end
    it "changes state when some user in current game confirms it" do
      g = Game.new("p1", "p2")
      g.confirmed_by("m1")
      g.state_name.must_equal :created
      g.confirmed_by("p1")
      g.state_name.must_equal :first_confirmed
      g.confirmed_by "m2"
      g.state_name.must_equal :first_confirmed
      g.confirmed_by "p2"
      g.state_name.must_equal :ready
    end
    describe "main gameplay" do
      it "should be playable only after ready state" do
        g = Game.new("p1", "p2")
        g.confirm1
        g.confirm2
        if g.ready?
          g.prepare_cards
        end
      end
      it "should allow players to move one after another"
    end
    describe "finishing" do
      it "should allow to finish game from any stage"
      it "should find who is winner by player states"
      it "should also find when there is a draw"
      it "should tell GameServer that the game was finished and it can be moved from @games only after winner is found"
    end
  end
  
end