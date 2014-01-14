require 'minitest/autorun'
require '../game.rb'

describe "User", "User primitive test" do
  describe "new method call" do
    it "should create new User object" do
      User.new("user1").must_be_instance_of User
    end
  end
end