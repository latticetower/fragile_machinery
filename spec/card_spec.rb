require 'minitest/autorun'
require '../../lib/card.rb'

describe "Card", "Card primitive test" do
  describe "new method call" do
    it "should create new Card object" do
      Card.new.must_be_instance_of Card
    end
  end
end