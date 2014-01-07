require 'minitest/autorun'
require '../lib/game_server.rb'

describe "GameServer", "GameServer primitive test" do
  describe "new method call" do
    it "should create new GameServer object" do
      GameServer.new.must_be_instance_of GameServer
    end
  end
end