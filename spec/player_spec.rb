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
        p = Player.new("p1")
        p.deck_size
      end
      it "should not be empty after calling load method" do
        p = Player.new("p1")
        p.deck_size.must_equal 0
        p.load_deck
        p.deck_size.wont_equal 0
        #@first_player.shuffle_deck!
        #@first_player.take_from_deck(5)
      end
    end
  end
end