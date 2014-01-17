require 'minitest/autorun'
require File.dirname(__FILE__) + '/../lib/game.rb'

describe "User", "User primitive test" do
  describe "new method call" do
    it "should create new User object" do
      User.new("user1").must_be_instance_of User
    end
  end
  describe "serialization" do
    it "in json it must contain nicknames only" do
      user = User.new "ppp"
      user.to_json
    end
  end
end