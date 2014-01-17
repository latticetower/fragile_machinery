require 'minitest/autorun'
require File.dirname(__FILE__) + '/../lib/board_card.rb'

describe "BoardCard", "BoardCard primitive test" do
  describe "new method call" do
    it "should create new BoardCard object" do
      BoardCard.new(Card.new("ddd")).must_be_instance_of BoardCard
    end
  end
  describe "lifetime and activity" do
    it "should be created with zero lifetime" do
      bc = BoardCard.new(Card.new("ddd"))
      bc.lifetime.must_equal 0
    end
    it "should change lifetime parameter after call to inc_lifetime method" do
      BoardCard.new(Card.new("ddd")).inc_lifetime.lifetime.must_equal 1
      BoardCard.new(Card.new("ddd")).inc_lifetime.active?.must_equal true
      BoardCard.new(Card.new("ddd")).inc_lifetime.exhausted?.wont_equal true
    end
    it "should become exhausted and inactive after certain amount of time" do
      bc = BoardCard.new(Card.new("ddd"))
      bc.inc_lifetime(Card::BASIC_LIFETIME - 1)
      bc.active?.must_equal true
      bc.exhausted?.wont_equal true
      bc.inc_lifetime.exhausted?.must_equal true
      bc.active?.wont_equal true
    end
  end
end