=begin
Almost God class - rules everything
stores information about open games & users
=end
class GameServer
  attr_reader :user_list # stores array or hash of all server users
  #TODO: if hash - should use unique connection identifier as a key
  
  def initialize
    @user_list = Array.new
  end
  
  # api for communicating with event_machine classes
  def add_user(user)
    @user_list ||= []
    @user_list << user 
  end
end