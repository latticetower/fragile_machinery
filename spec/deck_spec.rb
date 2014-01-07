require 'minitest/autorun'
require '../lib/deck.rb'

describe "Deck", "Deck primitive test" do
  describe "new method call" do
    it "should create new Deck object" do
      Deck.new.must_be_instance_of Deck
    end
  end
end