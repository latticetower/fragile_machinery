#!/usr/bin/env ruby
#
# server_1
require 'json'
require 'rubygems'
require 'eventmachine'
require File.dirname(__FILE__) + '/lib/game_server.rb'
require File.dirname(__FILE__) + '/lib/user.rb'


class EMGameServer
  @@game_server = GameServer.new
  @@connections = {}
  attr_reader :user_id
  attr_reader :name
  @connection
  @@max_users = 0
  # broadcast channels & stuff
  # chat channel
  def self.chat_channel
    @@chat_channel ||= EM::Channel.new
  end
  # user_list channel
  def self.user_list_channel
    @@users_channel ||= EM::Channel.new
  end
  # end of broadcast channels& stuff
  def initialize(connection)
    @@max_users += 1
    @connection = connection
    @user_id = "user_" + @@max_users.to_s
    
    @name = @user_id
    @@game_server.add_user(@user_id, User.new(@user_id))
    @@connections[@user_id] = self    
  end
  
  def subscribe
    @chat_sid = EMGameServer.chat_channel.subscribe{|msg| @connection.send msg }
    @users_sid = EMGameServer.user_list_channel.subscribe{|msg| @connection.send msg}
  end
  
  def unsubscribe
    EMGameServer.chat_channel.unsubscribe(@chat_sid)
    EMGameServer.user_list_channel.unsubscribe(@users_sid)
  end
  
  def self.send_user_list_to_all
    user_list_with_params =  {
      'data' => @@game_server.user_list(:json),
      'type' => 'user_list'
    }.to_json
    EMGameServer.user_list_channel.push user_list_with_params
  end

  def post_init
    puts "-- someone connected to the echo server!"
  end

  def new_user
    @user_id = data.sub("new user ", "").strip
    
  end
  
  def disconnect
    @@game_server.disconnect(@user_id)
    @@connections.delete(@user_id)
  end
  
  def send msg
    @connection.send msg
  end
  
  def self.send_to_all(msg)
    @@connections.each do |k, v|
      v.send msg
    end
  end
    
  def process_message msg
    puts "got message: #{msg}"
    case msg
      when /u list/i
        puts "in ulist handler"
        send_user_list
      when /u rename [A-Za-z0-9]+/
        puts "renaming"
        name = msg.sub("u rename ", "").sub(/[^A-Za-z0-9]/, '')
        rename_user(name) if name.size > 0
      when /m /
        puts "broadcast message"
        EMGameServer.send_to_all(msg.sub("m ", "#{@name}: "))
      #game commands
      when /g with user_[0-9]+/i
        user_id2 = msg.sub("g with ", "").gsub(/[^A-Za-z0-9_]/, '').strip
        puts "#{user_id} sent game request to #{user_id2}"
        send_game_request(user_id2)
      when /g accept user_[0-9]+/
      
        user_id2 = msg.sub("g accept ", "").gsub(/[^A-Za-z0-9_]/, '').strip
        puts "#{user_id2} accepted request from #{user_id}"
        @@game_server.game_ready(user_id, user_id2)
      when /g reject user_[0-9]+/
        user_id2 = msg.sub("g reject ", "").gsub(/[^A-Za-z0-9_]/, '').strip
        puts "#{user_id2} rejected request from #{user_id}"
        @@game_server.game_reject(user_id, user_id2)
        
      when /g hand/
        send_hand
      when /g state/
        send_game_state(@connection)
      when /g put [0-9]+/
        card_id = msg.sub("g put ", "").gsub(/[^0-9]/, '').strip
        put_user_card_to_board(card_id)
      when /g target [0-9]+/
        # not implemented. sets card target
      when /g next/
        send_next_move
      when /g giveup/
        send_giveup
    end
  end
  
  # service methods
  def put_user_card_to_board(card_id)
    # to be implemented
  end
  
  def send_next_move
    # to be implemented
  end
  
  def send_giveup
    # to be implemented
  end
  
  def send_user_list
    @connection.send @@game_server.user_list(:json) 
  end
    
  def rename_user(name)
    @@game_server.rename(@user_id, name)
    @name = name
  end
  
  def send_game_request(user_id2)
    return unless @@connections.has_key? user_id2
    @@game_server.create_game(@user_id, user_id2)
    @@connections[user_id2].send "#{user_id} requested game <a href='#' onclick='sendAccept(\"#{user_id}\")'>accept</a> or <a href='#' onclick='sendDecline(\"#{user_id}\")'>decline</a>"
    #TODO: need to send json request
    # also user_id sends request - it means he accepts the game
  end
  
  #method sends to user his cards in hand descriptions in json
  def send_hand
    puts hand.to_json
    hand = @@game_server.get_user_hand(user_id)
    @connection.send hand.to_json
  end
  def send_game_state(connection)
    puts game.to_json
    game = @@game_server.game_by_player(user_id)
    connection.send game.to_json
  end
  # end of service methods

  def receive_data data
    #send_data ">>> you sent: #{data}"
    puts "command recieved: #{data}"
    if data == "u list"
      
    end

    
    if data.index("new user") == 0 
      @user_id = data.sub("new user ", "").strip
      @@game_server.add_user(user_id, User.new(@username))
      @@connections[@user_id] = self
    end
  end
  
  def unbind
    @@connections.delete(self.user_id)
    @@game_server.remove_user(user_id)
    puts "#{self.user_id} is out"
  end
end

 # EventMachine::run {
 #   EventMachine::start_server "127.0.0.1", 8081, EchoServer
#    puts 'running echo server on 8081'
#  }