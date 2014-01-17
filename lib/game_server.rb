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
    @games = Array.new
  end
  
  # api for communicating with event_machine classes
  def add_user(object_id, user)
    @users ||= {}
    @users[object_id] = user 
  end
  
  def rename(object_id, name)
    @users[object_id].name = name
  end
  
  def user_list(format = :string)
    case format
    when :json
      @users.to_json
    else
      @users.values.map{|user| user.name }.join ','
    end
  end
  
  # method creates game for users specified and pushes is to @games array
  def create_game(user1, user2)
    @games << Game.new(user1, user2)
  end
  
  def game_ready(user1, user2)
    @games.select{ |game| game.played_by?(user1, user2) }.map{|game| game.ready!}
    #TODO: should add method to game to return users
  end
  def game_reject(user1, user2)
    @games.delete_if{ |game| game.played_by?(user1, user2) }
  end
  
  def change_state(new_state)
    @games.select{ |game| game.played_by?(user1, user2) }.map{|game| game.ready!}
  end
  
  def disconnect_all
    @users.clear
    @games.clear
  end
  
  def disconnect(username)
    @users.delete(username)
    @games.select{ |game| game.played_by?(username) }.map{|game| game.finish!}
    #TODO: should also find all games with this user and finish them all
  end
end