=begin
Almost God class - rules everything
stores information about open games & users
=end
class GameServer
  attr_reader :users # stores array or hash of all server users
  attr_reader :games # stores array of all open games
  #TODO: if hash - should use unique connection identifier as a key
  
  def initialize
    @users = Array.new
    @games = Array.new
  end
  
  # api for communicating with event_machine classes
  def add_user(user)
    @users ||= []
    @users << user 
  end
  
  # method creates game for users specified and pushes is to @games array
  def create_game(user1, user2)
    @games << Game.new(user1, user2)
  end
end