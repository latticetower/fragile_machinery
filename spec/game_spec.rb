require 'minitest/autorun'
require '../lib/game.rb'

describe "Game", "Game primitive test" do
  describe "new method call" do
    it "should create new Game object" do
      Game.new.must_be_instance_of Game
    end
  end
end