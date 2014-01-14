=begin
Almost God class - rules everything
stores information about open games & users
=end
class GameServer
  attr_reader :users # stores array or hash of all server users
  attr_reader :games # stores array of all open games
  #TODO: if hash - should use unique connection identifier as a key
  
  def initialize
    @users = Hash.new
    @games = Hash.new
  end
  
  # api for communicating with event_machine classes
  def add_user(name, user)
    @users ||= {}
    @users[name] = user 
  end
  
  def user_list
    @users.keys.join ','
  end
  
  # method creates game for users specified and pushes is to @games array
  def create_game(user1, user2)
    @games[[user1, user2].to_sym] = Game.new(user1, user2)
  end
  
  def game_ready(user1, user2)
    @games[[user1, user2].to_sym].ready!
  end
  def game_reject(user1, user2)
    @games[[user1, user2].to_sym] = nil
  end
  
  def change_state(new_state)
    @games[[user1, user2].to_sym].ready!
  end
end