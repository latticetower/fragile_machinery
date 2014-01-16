require 'minitest/autorun'
require File.dirname(__FILE__) + '/../lib/player.rb'

describe "Player", "Player primitive test" do
  describe "new method call" do
    it "should create new Player object" do
      Player.new("p1").must_be_instance_of Player
    end
  end
  describe "deck object" do
    describe "loading" do
      it "should be empty initially" do
        player = Player.new("p1")
        player.deck_size
      end
      
      it "should not be empty after calling load method" do
        player = Player.new("p1")
        player.deck_size.must_equal 0
        player.load_deck
        player.deck_size.wont_equal 0
        #@first_player.shuffle_deck!
        #@first_player.take_from_deck(5)
      end
      it "should take_from_deck upto deck_size cards" do
        player = Player.new("p1")
        player.load_deck
        size = player.deck_size
        player.take_from_deck(size + 1).must_equal size
        # let's try to get more cards
        player.take_from_deck(1).must_equal 0
      end
      
    end
  end
end