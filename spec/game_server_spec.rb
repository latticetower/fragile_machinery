require 'minitest/autorun'
require '../lib/game_server.rb'
require '../lib/user.rb'

describe "GameServer", "GameServer primitive test" do
  describe "new method call" do
    it "should create new GameServer object" do
      GameServer.new.must_be_instance_of GameServer
    end
    
  end
  describe "user_list method" do
    gs = GameServer.new
    it "should return nothing when userlist is empty, or some kind of error" do
      gs.user_list.must_equal ''
    end
    it "should return user nicknames as json" 
    it "should validly remove user when he disconnects" do
      gs.disconnect_all
      gs.add_user(User.new("n1"))
      gs.users.size.must_equal 1
      gs.disconnect("n1")
      gs.users.size.must_equal 0
    end
    
  end
end