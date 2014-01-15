require 'minitest/autorun'
require File.dirname(__FILE__) + '/../lib/player.rb'

describe "Player", "Player primitive test" do
  describe "new method call" do
    it "should create new Player object" do
      Player.new.must_be_instance_of Player
    end
  end
end