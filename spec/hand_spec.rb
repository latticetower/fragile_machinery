require 'minitest/autorun'
require File.dirname(__FILE__) + '/../lib/hand.rb'

describe "Hand", "Hand primitive test" do
  describe "new method call" do
    it "should create new Hand object" do
      Hand.new.must_be_instance_of Hand
    end
  end
end